tree --gitignore                    
.
├── appwrite.json
├── contracts
│   └── ccip
│       ├── CCIPEscrowManager.sol
│       └── CCIPPaymentRouter.sol
├── env.sample
├── eslint.config.mjs
├── next.config.ts
├── package.json
├── pnpm-lock.yaml
├── postcss.config.mjs
├── public
│   ├── file.svg
│   ├── globe.svg
│   ├── images
│   │   └── logo.png
│   ├── next.svg
│   ├── vercel.svg
│   └── window.svg
├── README.md
├── src
│   ├── api
│   │   ├── ccip
│   │   │   └── status.ts
│   │   ├── escrow
│   │   │   └── release
│   │   │       └── route.ts
│   │   └── test
│   ├── app
│   │   ├── accounts
│   │   │   ├── accountsClient.tsx
│   │   │   ├── create
│   │   │   │   ├── createClient.tsx
│   │   │   │   └── page.tsx
│   │   │   ├── [id]
│   │   │   │   └── page.tsx
│   │   │   └── page.tsx
│   │   ├── auth
│   │   │   ├── AuthClient.tsx
│   │   │   ├── complete-profile
│   │   │   │   └── page.tsx
│   │   │   ├── forgot-password
│   │   │   │   └── page.tsx
│   │   │   ├── login
│   │   │   │   └── page.tsx
│   │   │   ├── reset-password
│   │   │   │   └── page.tsx
│   │   │   ├── signup
│   │   │   │   └── page.tsx
│   │   │   └── verify
│   │   │       └── page.tsx
│   │   ├── cards
│   │   │   ├── cardsClient.tsx
│   │   │   ├── create
│   │   │   │   ├── createClient.tsx
│   │   │   │   ├── [id]
│   │   │   │   │   └── page.tsx
│   │   │   │   └── page.tsx
│   │   │   └── page.tsx
│   │   ├── DashboardClient.tsx
│   │   ├── exchange
│   │   │   ├── ExchangeClient.tsx
│   │   │   └── page.tsx
│   │   ├── favicon.ico
│   │   ├── globals.css
│   │   ├── history
│   │   │   ├── HistoryClient.tsx
│   │   │   └── page.tsx
│   │   ├── home
│   │   │   └── page.tsx
│   │   ├── HomeClient.tsx
│   │   ├── layout.tsx
│   │   ├── not-found.tsx
│   │   ├── page.tsx
│   │   ├── payment-links
│   │   ├── payment-requests
│   │   │   └── [id]
│   │   │       └── route.ts
│   │   ├── pitch
│   │   │   ├── pageClient.tsx
│   │   │   └── page.tsx
│   │   ├── receive
│   │   │   └── page.tsx
│   │   ├── requests
│   │   │   ├── create
│   │   │   │   └── page.tsx
│   │   │   ├── page.tsx
│   │   │   └── RequestsClient.tsx
│   │   ├── scan
│   │   │   ├── page.tsx
│   │   │   └── ScanClient.tsx
│   │   ├── send
│   │   │   ├── page.tsx
│   │   │   └── SendClient.tsx
│   │   ├── settings
│   │   │   ├── page.tsx
│   │   │   └── SettingsClient.tsx
│   │   ├── transactions
│   │   │   └── page.tsx
│   │   └── wallets
│   │       ├── create
│   │       │   └── page.tsx
│   │       ├── page.tsx
│   │       └── WalletsClient.tsx
│   ├── App.css
│   ├── App.tsx
│   ├── components
│   │   ├── accounts
│   │   │   ├── AccountDetails.tsx
│   │   │   └── AccountList.tsx
│   │   ├── AppShell.tsx
│   │   ├── auth
│   │   │   ├── AuthGuard.tsx
│   │   │   ├── GuestConversion.tsx
│   │   │   ├── GuestSessionButton.tsx
│   │   │   ├── OptionalAuthGuard.tsx
│   │   │   └── ProfileCompletion.tsx
│   │   ├── AuthGuard.tsx
│   │   ├── cards
│   │   │   ├── CardCreateForm.tsx
│   │   │   ├── CardDetails.tsx
│   │   │   └── CardList.tsx
│   │   ├── CrossChainPayment.tsx
│   │   ├── crypto
│   │   │   ├── AddressInput.tsx
│   │   │   ├── CryptoAmountInput.tsx
│   │   │   ├── CurrencySelector.tsx
│   │   │   ├── PriceChart.tsx
│   │   │   ├── TransactionItem.tsx
│   │   │   └── WalletCard.tsx
│   │   ├── dashboard
│   │   │   └── DynamicDashboard.tsx
│   │   ├── Dashboard.tsx
│   │   ├── DynamicDashboard.tsx
│   │   ├── ExchangeRateDisplay.tsx
│   │   ├── Header.tsx
│   │   ├── layout
│   │   │   ├── AppShell.tsx
│   │   │   ├── BottomNavigationFixed.tsx
│   │   │   ├── BottomNavigationNew.tsx
│   │   │   ├── BottomNavigation.tsx
│   │   │   ├── Header.tsx
│   │   │   ├── MobileNavigation.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   └── TopBar.tsx
│   │   ├── LoadingSpinner.tsx
│   │   ├── payment
│   │   │   ├── PaymentLinkForm.tsx
│   │   │   └── PaymentLinkList.tsx
│   │   ├── PaymentInterface.tsx
│   │   ├── PriceDisplay.tsx
│   │   ├── profile
│   │   │   ├── PaymentProfile.tsx
│   │   │   └── QRCodeGenerator.tsx
│   │   ├── providers.tsx
│   │   ├── scanner
│   │   │   └── QRScanner.tsx
│   │   ├── SearchParamsWrapper.tsx
│   │   ├── security
│   │   │   └── TwoFactorSettings.tsx
│   │   ├── transactions
│   │   │   └── TransactionHistory.tsx
│   │   └── ui
│   │       ├── Button.tsx
│   │       ├── Card.tsx
│   │       ├── Drawer.tsx
│   │       ├── Input.tsx
│   │       ├── Modal.tsx
│   │       ├── NotificationSystem.tsx
│   │       ├── Skeleton.tsx
│   │       └── Tabs.tsx
│   ├── config
│   │   └── chains.ts
│   ├── contexts
│   │   ├── AccountContext.tsx
│   │   ├── AuthContextClient.tsx
│   │   ├── AuthContext.tsx
│   │   ├── CardContext.tsx
│   │   ├── ExchangeRateContextClient.tsx
│   │   ├── ExchangeRateContext.tsx
│   │   ├── PaymentRequestContextClient.tsx
│   │   ├── PaymentRequestContext.tsx
│   │   ├── TransactionContextClient.tsx
│   │   ├── TransactionContext.tsx
│   │   ├── WalletContextClient.tsx
│   │   └── WalletContext.tsx
│   ├── hooks
│   │   └── useBlessNetwork.ts
│   ├── lib
│   │   ├── appwrite.ts
│   │   ├── auth.ts
│   │   ├── database.ts
│   │   ├── debug-db.ts
│   │   ├── exchangeRates.ts
│   │   ├── middleware
│   │   │   ├── auth.ts
│   │   │   ├── config.ts
│   │   │   ├── handlers.ts
│   │   │   └── utils.ts
│   │   ├── qr.ts
│   │   ├── storage.ts
│   │   ├── utils-clean.ts
│   │   ├── utils-new.ts
│   │   └── utils.ts
│   ├── middleware.ts
│   ├── services
│   │   └── ccipService.ts
│   ├── types
│   │   └── appwrite.d.ts
│   └── utils
│       └── index.ts
└── tsconfig.json

62 directories, 151 files
