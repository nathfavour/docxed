# Password Manager UI Animations

## General Principles
- **Smooth, Subtle:** Animations enhance clarity, not distract.
- **Consistent:** Same transitions for similar actions across platforms.
- **Performance:** Hardware-accelerated, 60fps target.
- **Accessible:** Reduced motion option for sensitive users.

---

## Page & Route Transitions

### Flutter (Mobile/Desktop)
- **Default:** Material fade-through or Cupertino slide (platform adaptive).
- **Custom:** 
    - Credentials/TOTP/Folders: Slide in from right, fade in content.
    - Dialogs/Modals: Scale and fade from center.
    - Bottom Sheets: Slide up from bottom.
- **Back Navigation:** Reverse animation (slide/fade out).

### Web
- **SPA Route Change:** Fade-through or slide, matching mobile.

---

## Component Animations

### Lists & Grids
- **Add Item:** Slide/fade in from bottom.
- **Remove Item:** Fade out, collapse height.
- **Reorder (Drag):** Item lifts, shadow, smooth reposition.

### FAB (Floating Action Button)
- **Show/Hide:** Scale and fade.
- **Tap:** Ripple effect.

### Buttons & Icons
- **Press:** Ripple or highlight.
- **Toggle (e.g., reveal password):** Icon rotates or morphs.

### Forms
- **Field Focus:** Subtle highlight/underline animation.
- **Validation Error:** Shake or color pulse.

### Password Strength Meter
- **Bar Fill:** Animate width/color as strength changes.

### Snackbars/Toasts
- **Appear:** Slide/fade from bottom.
- **Dismiss:** Fade out.

### Loaders/Skeletons
- **Loading:** Shimmer effect.
- **Progress:** Circular/linear animated indicators.

---

## Navigation Drawer/Sidebar
- **Open/Close:** Slide in/out, fade overlay (mobile).
- **Item Select:** Highlight with color/scale.

---

## Folder Tree
- **Expand/Collapse:** Smooth height/opacity transition, arrow rotates.

---

## Security Logs/Details
- **Show Details:** Expand/collapse with fade/slide.

---

## Responsive Adaptation
- **Layout Change:** Cross-fade or slide when switching between layouts (e.g., list to grid, sidebar collapse).

---

## Accessibility
- **Reduced Motion:** All transitions become simple fades or instant changes if OS/user requests reduced motion.

---

## Animation Timing
- **Duration:** 150–300ms for most transitions.
- **Easing:** Standard (ease-in-out), overshoot for playful elements.

---

> **Note:** Animations should never block user input or obscure sensitive data.
