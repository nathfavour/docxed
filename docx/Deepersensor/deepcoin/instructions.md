don't break any existing functioanlities.
don't edit any of my config files e.gi package.json, just list our the edits to be made.

---

## NERO Paymaster Integration

### Environment Variables Required
Add to your `.env.local`:
```
NEXT_PUBLIC_NERO_API_ENDPOINT=https://paymaster-testnet.nerochain.io
NERO_API_KEY=your_api_key_from_aa_platform
```

### Integration Points

1. **Core Utility** - `/src/utils/neroPaymaster.ts`
   - Handles JSON-RPC communication with Paymaster API
   - Implements `pm_supported_tokens`, `pm_sponsor_userop`, `pm_entrypoints`
   - Includes proper error handling following `/docx/nero/error_handling.md`

2. **React Hook** - `/src/hooks/useNeroPaymaster.ts`
   - Provides easy integration with loading/error states
   - Implements token caching (5-minute default) per best practices
   - Helper methods for common operations

3. **Wallet Integration** - Enhanced wallet auth to check paymaster support
   - Optional paymaster capability check during wallet connection
   - Stores paymaster support info in database

4. **Usage Examples**

```typescript
// Basic usage in a component
const { supportedTokens, sponsorUserOp, loading, error } = useNeroPaymaster({ 
  apiKey: 'your_api_key' 
});

// Check supported tokens
const tokens = await supportedTokens(walletAddress);

// Sponsor a transaction (free gas)
const sponsoredOp = await sponsorUserOp(userOperation, { type: 0 });

// Pay with ERC20 token
const paidOp = await sponsorUserOp(userOperation, { 
  type: 1, 
  token: '0xTokenAddress' 
});
```

### Payment Types (see `/docx/nero/payment_types.md`)
- **Type 0**: Free gas (sponsored by developer)
- **Type 1**: Prepay with ERC20 tokens
- **Type 2**: Postpay with ERC20 tokens

### Security Notes
- API keys are stored server-side only
- Client receives paymaster data but never the API key
- Follow `/docx/nero/best_practices.md` for production usage

### Error Handling
- Implements all standard JSON-RPC error codes from `/docx/nero/error_handling.md`
- Graceful fallbacks when paymaster is unavailable
- Proper retry logic for network issues
