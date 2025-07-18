#!/bin/bash

# Usage: ./undepended.sh <code_folder> [SRC_DEPTH] [-verbose]
# SRC_DEPTH: how many parent directories to check for src (default: 3)
# -verbose: print progress and status

set -e

VERBOSE=0
for arg in "$@"; do
    if [[ "$arg" == "-verbose" ]]; then
        VERBOSE=1
    fi
done

for cmd in realpath grep awk sed find dirname basename; do
    if ! command -v $cmd &>/dev/null; then
        echo "Error: '$cmd' is required but not installed."
        exit 1
    fi
done

if [ -z "$1" ]; then
    echo "Usage: $0 <code_folder> [SRC_DEPTH] [-verbose]"
    exit 1
fi

CODE_DIR="$(realpath "$1")"
SRC_DEPTH="${2:-3}"

cd "$CODE_DIR"

[ $VERBOSE -eq 1 ] && echo "[undepended] Scanning for source files..."

ALL_FILES=()
while IFS= read -r f; do
    ALL_FILES+=("$f")
done < <(find . -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) \
    ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/dist/*" ! -path "*/build/*" \
    ! -name "*test.*" ! -name "*spec.*" ! -name "*.stories.*" ! -name "*.storybook.*")

declare -A FILES_ABS_MAP
declare -A FILES_REL_MAP
for rel_file in "${ALL_FILES[@]}"; do
    abs_file="$(realpath "$rel_file")"
    FILES_ABS_MAP["$abs_file"]="$rel_file"
    FILES_REL_MAP["$rel_file"]="$abs_file"
done

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

[ $VERBOSE -eq 1 ] && echo "[undepended] Building tag import map..."

declare -A TAG_IMPORT_MAP
for rel_file in "${ALL_FILES[@]}"; do
    abs_file="${FILES_REL_MAP["$rel_file"]}"
    if [[ "$abs_file" == "$TAG_ROOT"* ]]; then
        tag_path="@/${abs_file#$TAG_ROOT/}"
        tag_path_no_ext="${tag_path%.*}"
        TAG_IMPORT_MAP["$tag_path_no_ext"]="$abs_file"
        if [[ "$(basename "$abs_file")" =~ ^index\.(js|jsx|ts|tsx)$ ]]; then
            dir_tag="${tag_path_no_ext%/index}"
            TAG_IMPORT_MAP["$dir_tag"]="$abs_file"
        fi
    fi
done

[ $VERBOSE -eq 1 ] && echo "[undepended] Skipping relative import map (on-demand calculation)..."

# Fast relative import resolver
resolve_relative_import() {
    local import_path="$1"
    local from_file="$2"
    
    local from_dir="$(dirname "$from_file")"
    local target_path="$from_dir/$import_path"
    
    # Try different extensions
    for ext in .js .jsx .ts .tsx; do
        local with_ext="$(realpath -m "$target_path$ext")"
        if [[ -n "${FILES_ABS_MAP["$with_ext"]}" ]]; then
            echo "$with_ext"
            return
        fi
    done
    
    # Try as directory with index
    for ext in .js .jsx .ts .tsx; do
        local index_path="$(realpath -m "$target_path/index$ext")"
        if [[ -n "${FILES_ABS_MAP["$index_path"]}" ]]; then
            echo "$index_path"
            return
        fi
    done
    
    # Try exact match
    local exact="$(realpath -m "$target_path")"
    if [[ -n "${FILES_ABS_MAP["$exact"]}" ]]; then
        echo "$exact"
        return
    fi
}

extract_imports() {
    awk '
    /import[[:space:]]+.*from[[:space:]]+["'"'"'][^"'"'"']+["'"'"']/ { 
        match($0, /from[[:space:]]+["'"'"']([^"'"'"']+)["'"'"']/, arr); print arr[1]; 
    }
    /require\([[:space:]]*["'"'"'][^"'"'"']+["'"'"']\)/ { 
        match($0, /require\([[:space:]]*["'"'"']([^"'"'"']+)["'"'"']\)/, arr); print arr[1]; 
    }
    /import\([[:space:]]*["'"'"'][^"'"'"']+["'"'"']\)/ { 
        match($0, /import\([[:space:]]*["'"'"']([^"'"'"']+)["'"'"']\)/, arr); print arr[1]; 
    }
    /export[[:space:]]+.*from[[:space:]]+["'"'"'][^"'"'"']+["'"'"']/ { 
        match($0, /from[[:space:]]+["'"'"']([^"'"'"']+)["'"'"']/, arr); print arr[1]; 
    }
    ' "$1"
}

declare -A IMPORTED_FILES
total_imports=0
file_count=0
for file in "${ALL_FILES[@]}"; do
    abs_file="${FILES_REL_MAP["$file"]}"
    ((file_count++))
    [ $VERBOSE -eq 1 ] && echo "[undepended] ($file_count/${#ALL_FILES[@]}) Scanning imports in $file"
    while read -r import_path; do
        [[ -z "$import_path" ]] && continue
        resolved=""
        if [[ "$import_path" == @/* ]]; then
            resolved="${TAG_IMPORT_MAP["$import_path"]}"
        elif [[ "$import_path" == src/* ]]; then
            src_rel="${import_path#src/}"
            resolved="${TAG_IMPORT_MAP["@/$src_rel"]}"
        elif [[ "$import_path" == ./* || "$import_path" == ../* ]]; then
            resolved="$(resolve_relative_import "$import_path" "$abs_file")"
        else
            continue
        fi
        [[ -n "$resolved" ]] && IMPORTED_FILES["$resolved"]=1 && ((total_imports++))
    done < <(extract_imports "$file")
done

UNUSED=()
for rel_file in "${ALL_FILES[@]}"; do
    abs_file="${FILES_REL_MAP["$rel_file"]}"
    base_name="$(basename "$abs_file")"
    if [[ "$base_name" =~ ^index\.(js|jsx|ts|tsx)$ && "$(dirname "$rel_file")" == "." ]]; then
        continue
    fi
    if [[ -z "${IMPORTED_FILES["$abs_file"]}" ]]; then
        UNUSED+=("$rel_file")
    fi
done

echo "Total files scanned: ${#ALL_FILES[@]}"
echo "Total imports resolved: $total_imports"

if [ ${#UNUSED[@]} -eq 0 ]; then
    echo "✅ No unused files found."
else
    echo "⚠️  Unused files:"
    for f in "${UNUSED[@]}"; do
        echo "$f"
    done
    echo "Total unused files: ${#UNUSED[@]}"
fi