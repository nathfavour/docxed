tree --gitignore
.
├── app
│   ├── favicon.ico
│   ├── globals.css
│   ├── layout.tsx
│   ├── page.tsx          # Landing/auth page
│   └── app
│       └── page.tsx      # Main app shell (all-in-one SPA)
├── components
│   ├── chat
│   │   ├── ChatList.tsx
│   │   ├── ChatWindow.tsx
│   │   ├── MessageInput.tsx
│   │   ├── MessageList.tsx
│   │   ├── MessageItem.tsx
│   │   └── ChatHeader.tsx
│   ├── contacts
│   │   ├── ContactList.tsx
│   │   └── ContactItem.tsx
│   ├── devices
│   │   ├── DeviceList.tsx
│   │   └── DeviceItem.tsx
│   ├── settings
│   │   ├── ProfileForm.tsx
│   │   ├── SecuritySettings.tsx
│   │   ├── RecoverySettings.tsx
│   │   └── ExtensionSettings.tsx
│   ├── auth
│   │   ├── LoginPanel.tsx
│   │   ├── RegisterPanel.tsx
│   │   ├── RecoveryPanel.tsx
│   │   └── TwoFactorPanel.tsx
│   ├── panels
│   │   ├── PrimarySidebar.tsx
│   │   ├── SecondaryPanel.tsx
│   │   ├── ProfilePanel.tsx
│   │   ├── CallPanel.tsx
│   │   ├── SettingsPanel.tsx
│   │   ├── ChatPanel.tsx
│   │   └── ExtensionsPanel.tsx
│   ├── overlays
│   │   ├── Modal.tsx
│   │   ├── Drawer.tsx
│   │   ├── PatternOverlay.tsx
│   │   └── AnimationPreviewOverlay.tsx
│   ├── ui
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Avatar.tsx
│   │   ├── Dropdown.tsx
│   │   ├── Tooltip.tsx
│   │   └── Spinner.tsx
│   └── layout
│       ├── AppShell.tsx
│       ├── Sidebar.tsx
│       ├── Topbar.tsx
│       └── MainLayout.tsx
├── hooks
│   ├── useAuth.ts
│   ├── useChats.ts
│   ├── useMessages.ts
│   ├── useContacts.ts
│   ├── useDevices.ts
│   ├── useSettings.ts
│   ├── useCredibility.ts
│   ├── useRecovery.ts
│   ├── useExtensions.ts
│   └── usePanels.ts
├── lib
│   ├── appwrite.ts
│   ├── encryption.ts
│   ├── credibility.ts
│   ├── recovery.ts
│   ├── username.ts
│   ├── validators.ts
│   └── utils.ts
├── store
│   ├── authStore.ts
│   ├── chatStore.ts
│   ├── messageStore.ts
│   ├── contactStore.ts
│   ├── deviceStore.ts
│   ├── settingsStore.ts
│   ├── extensionStore.ts
│   └── panelStore.ts
├── types
│   ├── appwrite.d.ts
│   ├── chat.d.ts
│   ├── message.d.ts
│   ├── user.d.ts
│   ├── contact.d.ts
│   ├── device.d.ts
│   ├── extension.d.ts
│   └── credibility.d.ts
├── context
│   ├── AuthContext.tsx
│   ├── ChatContext.tsx
│   ├── SettingsContext.tsx
│   ├── ExtensionContext.tsx
│   └── PanelContext.tsx
├── middleware
│   ├── auth.ts
│   └── rateLimit.ts
├── services
│   ├── chatService.ts
│   ├── messageService.ts
│   ├── userService.ts
│   ├── contactService.ts
│   ├── deviceService.ts
│   ├── extensionService.ts
│   └── credibilityService.ts
├── utils
│   ├── encryptionUtils.ts
│   ├── dateUtils.ts
│   ├── stringUtils.ts
│   └── validationUtils.ts
├── themes
│   ├── defaultDark.ts
│   ├── defaultLight.ts
│   ├── types.ts
│   ├── ThemeProvider.tsx
│   └── utils.ts
├── patterns
│   ├── geometric.ts
│   ├── emoji.ts
│   ├── doodle.ts
│   └── PatternSelector.tsx
├── animations
│   ├── levels.ts
│   ├── transitions.ts
│   ├── CircularWipe.tsx
│   ├── StickerAnimations.tsx
│   └── AnimationPreview.tsx
├── README.md
├── appwrite.json
├── eslint.config.mjs
├── next.config.ts
├── package.json
├── pnpm-lock.yaml
├── postcss.config.mjs
├── public
│   ├── file.svg
│   ├── globe.svg
│   ├── next.svg
│   ├── vercel.svg
│   └── window.svg
├── tsconfig.json
└── types
    └── appwrite.d.ts

4 directories, 18 files
│   └── utils.ts
├── patterns
│   ├── geometric.ts
│   ├── emoji.ts
│   ├── doodle.ts
│   └── PatternSelector.tsx
├── animations
│   ├── levels.ts
│   ├── transitions.ts
│   ├── CircularWipe.tsx
│   ├── StickerAnimations.tsx
│   └── AnimationPreview.tsx
├── README.md
├── appwrite.json
├── eslint.config.mjs
├── next.config.ts
├── package.json
├── pnpm-lock.yaml
├── postcss.config.mjs
├── public
│   ├── file.svg
│   ├── globe.svg
│   ├── next.svg
│   ├── vercel.svg
│   └── window.svg
├── tsconfig.json
└── types
    └── appwrite.d.ts

4 directories, 18 files
