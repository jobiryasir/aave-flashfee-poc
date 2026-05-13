# Aave FlashFee PoC

## Bug
flashFee() depends on msg.sender causing EIP-3156 violation.

## Impact
- Inconsistent fee quotes
- Integration mismatch

## Run
forge test --fork-url MAINNET_RPC -vvvv
