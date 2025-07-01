# Password Manager Appwrite Functions

## Functions

### generateStrongPassword
- **Purpose:** Generate a secure password.
- **Trigger:** HTTP POST
- **Input:** length, includeUppercase, includeLowercase, includeNumbers, includeSymbols
- **Output:** password

---

### checkPasswordStrength
- **Purpose:** Evaluate password strength.
- **Trigger:** HTTP POST
- **Input:** password
- **Output:** score, feedback

---

### logSecurityEvent
- **Purpose:** Write to SecurityLogs.
- **Trigger:** HTTP POST or internal
- **Input:** userId, eventType, ipAddress, userAgent, details
- **Output:** success, logId

---

### fetchFavicon (optional)
- **Purpose:** Fetch favicon for a URL.
- **Trigger:** HTTP POST
- **Input:** url
- **Output:** faviconUrl

---

### sendNotification
- **Purpose:** Send email/push notifications.
- **Trigger:** HTTP POST or event
- **Input:** userId, type, template, data
- **Output:** status
