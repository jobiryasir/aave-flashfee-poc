# Aave FlashFee PoC

## Issue
flashFee() should behave deterministically for the same input parameters (token, amount), but its output may vary depending on access-controlled state, affecting quote consistency expectations.

---

## Impact
- Breaks deterministic pricing assumptions for external integrators
- May lead to incorrect fee estimation in off-chain systems
- Can cause integration mismatch with EIP-3156 compatible tooling
- Reduces reliability of flash loan fee quoting for routers and aggregators

---

## Technical Summary
The flashFee() function is expected to act as a pure quote function. However, due to internal access-control checks (e.g., flash borrower whitelisting logic), fee output may not be strictly invariant across different caller contexts.

This creates inconsistencies in environments where fee estimation is performed off-chain or via intermediary contracts.

---

## Test Instructions

Run with Foundry:

```bash
forge test --fork-url MAINNET_RPC -vvvv
