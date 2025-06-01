# Global LMS Database Schema Design (Appwrite)

## 1. Databases

- `core`
- `users`
- `courses`
- `institutions`
- `ai`
- `analytics`
- `integrations`
- `web3`  <!-- Added for blockchain/web3 integration -->

---

## 2. Collections & Attributes

### 2.1. `core` Database

#### `settings`
- `key` (string, unique)
- `value` (json)
- Index: `key`

#### `roles`
- `name` (string, unique)
- `permissions` (array)
- Index: `name`

---

### 2.2. `users` Database

#### `users`
- `user_id` (string, unique)
- `email` (string, unique)
- `profile` (json)
- `role_id` (string, ref: `roles`)
- `institution_id` (string, ref: `institutions`)
- `wallet_address` (string, unique, optional) <!-- Added for web3 -->
- Indexes: `email`, `role_id`, `institution_id`, `wallet_address`

#### `user_profiles`
- `user_id` (string, unique, ref: `users`)
- `bio` (string)
- `avatar_url` (string)
- `preferences` (json)
- Index: `user_id`

---

### 2.3. `courses` Database

#### `courses`
- `course_id` (string, unique)
- `title` (string)
- `description` (string)
- `institution_id` (string, ref: `institutions`)
- `creator_id` (string, ref: `users`)
- `metadata` (json)
- `nft_contract_address` (string, optional) <!-- Added for blockchain credentialing -->
- Indexes: `institution_id`, `creator_id`, `nft_contract_address`

#### `modules`
- `module_id` (string, unique)
- `course_id` (string, ref: `courses`)
- `title` (string)
- `order` (int)
- Index: `course_id`

#### `lessons`
- `lesson_id` (string, unique)
- `module_id` (string, ref: `modules`)
- `title` (string)
- `content` (json)
- `order` (int)
- Index: `module_id`

#### `enrollments`
- `enrollment_id` (string, unique)
- `user_id` (string, ref: `users`)
- `course_id` (string, ref: `courses`)
- `status` (string)
- `progress` (json)
- `certificate_token_id` (string, optional, ref: `web3.certificates`) <!-- Added for blockchain certificates -->
- Indexes: `user_id`, `course_id`, `certificate_token_id`

#### `assessments`
- `assessment_id` (string, unique)
- `course_id` (string, ref: `courses`)
- `type` (string)
- `metadata` (json)
- Index: `course_id`

#### `submissions`
- `submission_id` (string, unique)
- `assessment_id` (string, ref: `assessments`)
- `user_id` (string, ref: `users`)
- `content` (json)
- `grade` (float)
- Indexes: `assessment_id`, `user_id`

---

### 2.4. `institutions` Database

#### `institutions`
- `institution_id` (string, unique)
- `name` (string)
- `type` (string)
- `metadata` (json)
- Index: `name`

#### `institution_integrations`
- `integration_id` (string, unique)
- `institution_id` (string, ref: `institutions`)
- `type` (string)
- `config` (json)
- Index: `institution_id`

---

### 2.5. `ai` Database

#### `ai_models`
- `model_id` (string, unique)
- `name` (string)
- `type` (string)
- `metadata` (json)
- Index: `name`

#### `ai_recommendations`
- `recommendation_id` (string, unique)
- `user_id` (string, ref: `users`)
- `course_id` (string, ref: `courses`)
- `data` (json)
- Indexes: `user_id`, `course_id`

---

### 2.6. `analytics` Database

#### `events`
- `event_id` (string, unique)
- `user_id` (string, ref: `users`)
- `type` (string)
- `timestamp` (datetime)
- `data` (json)
- Indexes: `user_id`, `type`, `timestamp`

#### `metrics`
- `metric_id` (string, unique)
- `name` (string)
- `value` (float)
- `timestamp` (datetime)
- Index: `name`, `timestamp`

---

### 2.7. `integrations` Database

#### `external_integrations`
- `integration_id` (string, unique)
- `type` (string)
- `config` (json)
- `status` (string)
- Index: `type`

---

### 2.8. `web3` Database <!-- New section for blockchain/web3 -->

#### `wallets`
- `wallet_address` (string, unique)
- `user_id` (string, ref: `users`)
- `network` (string)
- `metadata` (json)
- Index: `wallet_address`, `user_id`

#### `transactions`
- `tx_id` (string, unique)
- `wallet_address` (string, ref: `wallets`)
- `type` (string)
- `amount` (float)
- `status` (string)
- `timestamp` (datetime)
- `metadata` (json)
- Index: `wallet_address`, `type`, `timestamp`

#### `certificates`
- `token_id` (string, unique)
- `user_id` (string, ref: `users`)
- `course_id` (string, ref: `courses`)
- `wallet_address` (string, ref: `wallets`)
- `contract_address` (string)
- `issued_at` (datetime)
- `metadata` (json)
- Index: `user_id`, `course_id`, `wallet_address`, `contract_address`

#### `nft_contracts`
- `contract_address` (string, unique)
- `course_id` (string, ref: `courses`)
- `network` (string)
- `metadata` (json)
- Index: `contract_address`, `course_id`

---

## 3. Relationships

- `users.role_id` → `core.roles.name`
- `users.institution_id` → `institutions.institution_id`
- `users.wallet_address` → `web3.wallets.wallet_address`
- `courses.institution_id` → `institutions.institution_id`
- `courses.creator_id` → `users.user_id`
- `courses.nft_contract_address` → `web3.nft_contracts.contract_address`
- `modules.course_id` → `courses.course_id`
- `lessons.module_id` → `modules.module_id`
- `enrollments.user_id` → `users.user_id`
- `enrollments.course_id` → `courses.course_id`
- `enrollments.certificate_token_id` → `web3.certificates.token_id`
- `assessments.course_id` → `courses.course_id`
- `submissions.assessment_id` → `assessments.assessment_id`
- `submissions.user_id` → `users.user_id`
- `ai_recommendations.user_id` → `users.user_id`
- `ai_recommendations.course_id` → `courses.course_id`
- `institution_integrations.institution_id` → `institutions.institution_id`
- `web3.wallets.user_id` → `users.user_id`
- `web3.transactions.wallet_address` → `web3.wallets.wallet_address`
- `web3.certificates.user_id` → `users.user_id`
- `web3.certificates.course_id` → `courses.course_id`
- `web3.certificates.wallet_address` → `web3.wallets.wallet_address`
- `web3.certificates.contract_address` → `web3.nft_contracts.contract_address`
- `web3.nft_contracts.course_id` → `courses.course_id`

---

## 4. Notes

- Use JSON fields for extensibility (e.g., `metadata`, `preferences`, `config`).
- Indexes on foreign keys and frequently queried fields.
- Modular databases allow for scaling and plug-and-play integrations.
- Designed for multi-tenancy, extensibility, and AI-powered features.
- Web3 integration enables on-chain credentials, NFT-based certificates, wallet-based authentication, and blockchain-powered transactions.
- All web3 features are optional and seamlessly integrated for maximum flexibility.

- appwrite doesn't have a json type, so we use string for json fields, using JSON.stringify() and JSON.parse() for storage and retrieval.
- except explicitly specified, strings have a max length of 255 characters, while json (which are unique kind of strings) are max 1000.
