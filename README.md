# Vesting Smart Contract

A custom ERC20 token vesting solution implemented in Solidity without using OpenZeppelin libraries.

## Features

- ✅ Custom vesting schedules with cliff period
- ✅ Linear token release after cliff
- ✅ Multiple beneficiary management
- ✅ Emergency withdrawal function
- ✅ No dependencies on OpenZeppelin
- ✅ Comprehensive input validation

## Contract Overview

This contract allows:
- Owners to create vesting schedules with configurable durations
- Beneficiaries to claim tokens as they vest
- Transparent tracking of allocations and claims

## Functions

### Owner Functions
| Function | Description |
|----------|-------------|
| `setTokenAddress(address)` | Sets ERC20 token address |
| `addBeneficiary(address,uint256)` | Adds beneficiary with allocation |
| `setCliffandVestinDuration(uint256,uint256)` | Configures vesting periods |
| `start()` | Begins vesting schedule |
| `emergencyWithdraw(uint256)` | Emergency token withdrawal |

### Beneficiary Functions
| Function | Description |
|----------|-------------|
| `claim()` | Claims vested tokens |
| `calculateClaimableAmount(address)` | Checks claimable amount |
| `getVestingInfo(address)` | Views allocation/claimed amounts |

## Vesting Logic

Before Cliff End: 0% vested
During Vesting: Linear vesting
After Vesting End: 100% vested


Calculation:  
`claimable = (totalAllocation × timeSinceCliffEnd) / vestingPeriod - totalClaimed`

## Safety Features

- Owner-restricted sensitive functions
- Zero-address checks
- Underflow/overflow protection
- Balance verification before transfers
- Time-based vesting validation

## Usage Flow

1. Deploy contract
2. Set token address
3. Configure durations (cliff + vesting)
4. Add beneficiaries
5. Start vesting schedule
6. Beneficiaries claim after cliff

## Development Showcase

This implementation demonstrates:

- Custom smart contract architecture
- Secure Solidity patterns
- Time-based calculations
- Role-based access control
- ERC20 integration
- Gas-efficient design
- Comprehensive edge case handling


Note: Contract should not be deployed in mainnet for commerical purpose this is just a raw unaudited demo to show off my solidity skills! 
