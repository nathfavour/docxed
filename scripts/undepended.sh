#!/bin/bash

# Usage: ./undepended.sh <code_folder> [SRC_DEPTH]
# SRC_DEPTH: how many parent directories to check for src (default: 3)

set -e

for cmd in realpath grep awk sed find dirname basename; do
    if ! command -v $cmd &>/dev/null; then
        echo "Error: '$cmd' is required but not installed."
        exit 1
    fi
done

if [ -z "$1" ]; then
    echo "Usage: $0 <code_folder> [SRC_DEPTH]"
    exit 1
fi

CODE_DIR="$(realpath "$1")"
SRC_DEPTH="${2:-3}"

cd "$CODE_DIR"

# Get all files
ALL_FILES=$(find . -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) \
    ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/dist/*" ! -path "*/build/*" \
    ! -name "*test.*" ! -name "*spec.*" ! -name "*.stories.*" ! -name "*.storybook.*")

# Maps for file tracking
declare -A FILES_ABS_MAP          # absolute_path -> relative_path
declare -A FILES_REL_MAP          # relative_path -> absolute_path
declare -A TAG_IMPORT_MAP         # tag_import -> absolute_path
declare -A RELATIVE_IMPORT_MAP    # from_file:relative_import -> absolute_path
declare -A IMPORTED_FILES         # absolute_path -> 1 (if imported)

echo "Analyzing $(echo "$ALL_FILES" | wc -l) files..."

# Step 1: Build file maps
while IFS= read -r rel_file; do
    abs_file="$(realpath "$rel_file")"
    FILES_ABS_MAP["$abs_file"]="$rel_file"
    FILES_REL_MAP["$rel_file"]="$abs_file"
done <<< "$ALL_FILES"

# Step 2: Analyze tag imports (@/) to understand mapping
find_tag_root() {
    local dir="$CODE_DIR"
    for ((i=0; i<=SRC_DEPTH; i++)); do
        if [ -d "$dir/src" ]; then
            echo "$dir/src"
            return
        fi
        dir="$(dirname "$dir")"
    done
    echo "$CODE_DIR"
}

TAG_ROOT="$(find_tag_root)"

# Step 3: Build comprehensive import maps for each file
build_import_maps() {
    # Build tag import map
    for rel_file in $(echo "$ALL_FILES"); do
        abs_file="${FILES_REL_MAP["$rel_file"]}"
        
        # Remove leading ./
        clean_rel="${rel_file#./}"
        
        # Calculate tag import path relative to TAG_ROOT
        if [[ "$abs_file" == "$TAG_ROOT"* ]]; then
            tag_path="@/${abs_file#$TAG_ROOT/}"
            # Remove extension for tag imports
            tag_path_no_ext="${tag_path%.*}"
            TAG_IMPORT_MAP["$tag_path_no_ext"]="$abs_file"
            
            # Also map directory index files
            if [[ "$(basename "$abs_file")" =~ ^index\.(js|jsx|ts|tsx)$ ]]; then
                dir_tag="${tag_path_no_ext%/index}"
                TAG_IMPORT_MAP["$dir_tag"]="$abs_file"
            fi
        fi
    done
    
    # Build relative import maps for each file
    for from_rel in $(echo "$ALL_FILES"); do
        from_abs="${FILES_REL_MAP["$from_rel"]}"
        from_dir="$(dirname "$from_abs")"
        
        for to_rel in $(echo "$ALL_FILES"); do
            to_abs="${FILES_REL_MAP["$to_rel"]}"
            
            # Calculate relative path from from_file to to_file
            rel_import="$(realpath --relative-to="$from_dir" "$to_abs")"
            
            # Normalize relative import
            if [[ "$rel_import" != /* ]]; then
                rel_import="./$rel_import"
            fi
            
            # Remove extension variations
            for ext in .js .jsx .ts .tsx; do
                rel_no_ext="${rel_import%$ext}"
                if [[ "$rel_no_ext" != "$rel_import" ]]; then
                    RELATIVE_IMPORT_MAP["$from_abs:$rel_no_ext"]="$to_abs"
                fi
            done
            
            # Handle index files
            if [[ "$(basename "$to_abs")" =~ ^index\.(js|jsx|ts|tsx)$ ]]; then
                dir_rel="$(dirname "$rel_import")"
                if [[ "$dir_rel" == "." ]]; then
                    dir_rel="./."
                fi
                RELATIVE_IMPORT_MAP["$from_abs:$dir_rel"]="$to_abs"
            fi
        done
    done
}

echo "Building import maps..."
build_import_maps

# Step 4: Extract and resolve all imports
resolve_import() {
    local import_path="$1"
    local from_file="$2"
    
    # Tag imports (@/)
    if [[ "$import_path" == @/* ]]; then
        echo "${TAG_IMPORT_MAP["$import_path"]}"
        return
    fi
    
    # Relative imports
    if [[ "$import_path" == ./* || "$import_path" == ../* ]]; then
        echo "${RELATIVE_IMPORT_MAP["$from_file:$import_path"]}"
        return
    fi
    
    # src/ imports
    if [[ "$import_path" == src/* ]]; then
        local src_rel="${import_path#src/}"
        echo "${TAG_IMPORT_MAP["@/$src_rel"]}"
        return
    fi
}

echo "Analyzing imports..."
while IFS= read -r file; do
    abs_file="${FILES_REL_MAP["$file"]}"
    
    # Extract all import statements
    grep -Eo "(import[[:space:]]+[^;]*from[[:space:]]+['\"][^'\"]+['\"]|require\(['\"][^'\"]+['\"]\)|import\(['\"][^'\"]+['\"]\)|export[[:space:]]+[^;]*from[[:space:]]+['\"][^'\"]+['\"])" "$file" 2>/dev/null | \
    grep -Eo "['\"][^'\"]+['\"]" | \
    while read -r import_line; do
        import_path="${import_line//\"/}"
        import_path="${import_path//\'/}"
        
        # Skip node_modules and absolute imports (except our patterns)
        if [[ "$import_path" != .* && "$import_path" != @/* && "$import_path" != src/* ]]; then
            continue
        fi
        
        resolved="$(resolve_import "$import_path" "$abs_file")"
        if [[ -n "$resolved" ]]; then
            IMPORTED_FILES["$resolved"]=1
        fi
    done
done <<< "$ALL_FILES"

# Step 5: Find unused files
UNUSED=()
for rel_file in $(echo "$ALL_FILES"); do
    abs_file="${FILES_REL_MAP["$rel_file"]}"
    base_name="$(basename "$abs_file")"
    
    # Skip entry points
    if [[ "$base_name" =~ ^index\.(js|jsx|ts|tsx)$ && "$(dirname "$rel_file")" == "." ]]; then
        continue
    fi
    
    # Check if file is imported
    if [[ -z "${IMPORTED_FILES["$abs_file"]}" ]]; then
        UNUSED+=("$rel_file")
    fi
done

# Results
echo "Total files scanned: $(echo "$ALL_FILES" | wc -l)"
echo "Total imports resolved: ${#IMPORTED_FILES[@]}"

if [ ${#UNUSED[@]} -eq 0 ]; then
    echo "✅ No unused files found."
else
    echo "⚠️  Unused files:"
    for f in "${UNUSED[@]}"; do
        echo "$f"
    done
    echo "Total unused files: ${#UNUSED[@]}"
fi