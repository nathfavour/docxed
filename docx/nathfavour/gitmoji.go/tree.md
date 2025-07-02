 tree --gitignore
.
├── babel.config.json
├── jsconfig.json
├── LICENSE
├── package.json
├── README.md
├── src
│   ├── cli.ts
│   ├── commands
│   │   ├── commit
│   │   │   ├── guard.js
│   │   │   ├── index.js
│   │   │   ├── prompts.js
│   │   │   ├── withClient
│   │   │   │   └── index.ts
│   │   │   └── withHook
│   │   │       └── index.js
│   │   ├── config
│   │   │   ├── guard.js
│   │   │   ├── index.js
│   │   │   └── prompts.js
│   │   ├── hook
│   │   │   ├── create
│   │   │   │   └── index.js
│   │   │   ├── hook.js
│   │   │   ├── index.js
│   │   │   └── remove
│   │   │       └── index.js
│   │   ├── index.js
│   │   ├── list
│   │   │   └── index.js
│   │   ├── search
│   │   │   └── index.js
│   │   └── update
│   │       └── index.js
│   ├── constants
│   │   ├── commit.js
│   │   ├── configuration.js
│   │   └── flags.js
│   └── utils
│       ├── buildFetchOptions.js
│       ├── configurationVault
│       │   ├── getConfiguration.js
│       │   └── index.js
│       ├── emojisCache.js
│       ├── filterGitmojis.js
│       ├── findGitmojiCommand.js
│       ├── getAbsoluteHooksPath.js
│       ├── getDefaultCommitContent.js
│       ├── getEmojis.js
│       ├── isHookCreated.js
│       └── printEmojis.js
├── test
│   ├── cli.spec.ts
│   ├── commands
│   │   ├── commands.spec.js
│   │   ├── commit.spec.js
│   │   ├── config.spec.js
│   │   ├── hook.spec.js
│   │   ├── list.spec.js
│   │   ├── search.spec.js
│   │   ├── __snapshots__
│   │   │   ├── commands.spec.js.snap
│   │   │   ├── commit.spec.js.snap
│   │   │   ├── config.spec.js.snap
│   │   │   └── hook.spec.js.snap
│   │   ├── stubs.js
│   │   └── update.spec.js
│   ├── setupTests.js
│   ├── __snapshots__
│   │   └── cli.spec.ts.snap
│   └── utils
│       ├── buildFetchOptions.spec.js
│       ├── configurationVault
│       │   ├── defaults.spec.js
│       │   ├── getConfiguration.spec.js
│       │   ├── __snapshots__
│       │   │   └── defaults.spec.js.snap
│       │   └── vault.spec.js
│       ├── emojisCache.spec.js
│       ├── filterGitmojis.spec.js
│       ├── filterScopes.spec.js
│       ├── findGitmojiCommand.spec.js
│       ├── getAbsoluteHooksPath.spec.js
│       ├── getDefaultCommitContent.spec.js
│       ├── getEmojis.spec.js
│       ├── isHookCreated.spec.js
│       ├── printEmojis.spec.js
│       ├── __snapshots__
│       │   ├── emojisCache.spec.js.snap
│       │   ├── filterGitmojis.spec.js.snap
│       │   └── filterScopes.spec.js.snap
│       └── stubs.js
├── tsconfig.json
├── turbo.json
└── yarn.lock

24 directories, 72 files
