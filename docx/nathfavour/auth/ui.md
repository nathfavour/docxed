# Password Manager UI Structure

## General Principles
- **Uniform Design:** Consistent layout and navigation across mobile, desktop, and web.
- **Responsiveness:** Adaptive layouts using breakpoints (e.g., mobile <600px, tablet <1024px, desktop ≥1024px).
- **Modularity:** Reusable components for forms, lists, dialogs, etc.
- **Accessibility:** High contrast, keyboard navigation, screen reader support.
- **Security:** Sensitive data masked by default, explicit reveal actions.

---

## Layout

### App Shell
- **Header/AppBar:** Logo, app name, user avatar/menu, theme toggle.
- **Navigation Drawer/Sidebar:** (Desktop/Tablet) Persistent; (Mobile) Modal/drawer.
    - Home/Dashboard
    - Credentials
    - TOTP (2FA)
    - Folders
    - Security Logs
    - Backups
    - Settings
    - Logout
- **Main Content Area:** Dynamic, based on route.
- **Floating Action Button (FAB):** (Mobile) For quick add actions.

---

## Screens & Components

### 1. Authentication
- **Login/Register:** Email, password, social login, password visibility toggle.
- **2FA Prompt:** TOTP input, backup code option.
- **Forgot Password:** Email input, reset flow.

### 2. Dashboard/Home
- **Overview Cards:** Total credentials, recent activity, security alerts.
- **Quick Actions:** Add credential, backup vault, view logs.
- **Recent Items:** List of recently accessed credentials.

### 3. Credentials
- **Credential List:** Search, filter (by folder, tag), sort.
    - List/Grid toggle (responsive).
    - Each item: favicon, name, username (masked), tags, folder.
    - Actions: View, Edit, Copy Username/Password, Move, Delete.
- **Credential Detail:** 
    - All fields (name, url, username, password, notes, custom fields, favicon).
    - Password masked, reveal/copy buttons.
    - Edit, Delete, Move to Folder, Add Tag.
    - Activity log for this credential.
- **Add/Edit Credential Form:** 
    - Inputs for all fields, password generator, strength meter.
    - Folder picker, tag input, custom fields (dynamic).
    - Save/Cancel.

### 4. TOTP (2FA)
- **TOTP List:** Issuer, account name, masked secret, folder.
    - Actions: View, Edit, Copy Code, Delete.
- **TOTP Detail:** 
    - QR code, secret, algorithm, digits, period.
    - Current code with timer.
    - Edit/Delete.
- **Add/Edit TOTP Form:** 
    - Manual entry or QR scan.
    - All fields, folder picker.

### 5. Folders
- **Folder Tree/List:** Nested folders, expand/collapse.
    - Actions: Add, Rename, Move, Delete.
    - Drag-and-drop (desktop/tablet).
- **Folder Detail:** 
    - List credentials/TOTP in folder.
    - Edit folder, move, delete.

### 6. Security Logs
- **Log List:** Event type, timestamp, IP, device.
    - Filter by type/date.
    - View details (JSON).

### 7. Backups
- **Backup List:** Date, size, download/restore/delete.
- **Upload Backup:** File picker, drag-and-drop.
- **Create Backup:** Button, progress indicator.

### 8. Settings
- **Profile:** Avatar, name, email, change password.
- **Security:** 2FA setup, session management, device list.
- **Preferences:** Theme, language, notifications.
- **Danger Zone:** Delete account, export data.

---

## Components

- **Dialogs/Modals:** Confirmations, forms, info popups.
- **Snackbars/Toasts:** Success/error/info messages.
- **Loaders/Skeletons:** For async data.
- **Tooltips:** For icons/actions.
- **Responsive Grids/Lists:** Adaptive to screen size.

---

## Responsivity

- **Mobile:** Bottom navigation, FAB, full-screen dialogs, swipe actions.
- **Tablet:** Collapsible sidebar, split views.
- **Desktop:** Persistent sidebar, multi-column layouts, drag-and-drop.

---

## Theming

- **Light/Dark Mode:** User toggle, system preference.
- **Accent Colors:** For folders/tags.
- **Consistent Iconography:** Material/Fluent/Custom.

---

## Error & Empty States

- **Empty Lists:** Illustrations, call-to-action.
- **Error Boundaries:** Friendly error messages, retry options.

---

## Accessibility

- **Labels/ARIA:** For all interactive elements.
- **Keyboard Navigation:** Tab order, shortcuts.
- **Contrast & Font Size:** Adjustable.

---

> **Note:** All sensitive fields (passwords, secrets) are masked by default and require explicit user action to reveal/copy.
