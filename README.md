# Foundry FundMe Smart Contract

A decentralized funding platform built with Foundry that allows users to send ETH and keeps track of funders. This project demonstrates fundamental blockchain development concepts including price feeds, testing, and script automation.

## Overview

The FundMe contract is a crowdfunding smart contract that:
- Accepts ETH payments with a minimum USD threshold
- Uses Chainlink Price Feeds for ETH/USD conversion
- Maintains a record of funders and their contributions
- Includes withdrawal functionality restricted to the contract owner
- Supports both local and testnet deployments

## Features

- 📈 Real-time ETH/USD price conversion
- 💰 Minimum funding amount in USD
- 📝 Automated funder tracking
- 🔒 Secure owner-only withdrawals
- 🧪 Comprehensive test suite (unit & integration)
- 🛠 Multiple deployment options (local, testnet)
- 🔄 Gas-optimized withdrawal function

## Prerequisites

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- An RPC URL from a provider like [Alchemy](https://www.alchemy.com/) or [Infura](https://www.infura.com/) for testnet deployment

## Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/foundry-fund-me
cd foundry-fund-me
```

2. Install dependencies:
```bash
forge install
```

3. Build the project:
```bash
forge build
```

## Environment Setup

1. Copy the example environment file:
```bash
cp .env.example .env
```

2. Fill in your environment variables:
```plaintext
SEPOLIA_RPC_URL=your_sepolia_rpc_url
PRIVATE_KEY=your_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

## Usage

### Testing

Run the full test suite:
```bash
forge test
```

Run tests with verbosity:
```bash
forge test -vvv
```

Run a specific test:
```bash
forge test --match-test testFundUpdatesFundDataStructure
```

### Deployment

Deploy to local Anvil chain:
```bash
make deploy
```

Deploy to Sepolia testnet:
```bash
make deploy-sepolia
```

Deploy to zkSync (local):
```bash
make deploy-zk
```

### Contract Interaction

Fund the contract:
```bash
make fund SENDER_ADDRESS=your_address
```

Withdraw funds (owner only):
```bash
make withdraw SENDER_ADDRESS=owner_address
```

## Contract Structure

### FundMe.sol
- Main contract handling funding and withdrawals
- Uses Chainlink price feeds for ETH/USD conversion
- Implements fund tracking and minimum USD requirement

### PriceConverter.sol
- Library for ETH/USD price conversion
- Interfaces with Chainlink price feeds
- Handles conversion rate calculations

## Testing

### Unit Tests
Located in `test/Unit/FoundMeTest.t.sol`:
- Minimum USD requirement
- Owner verification
- Fund data structure updates
- Withdrawal functionality
- Gas optimization tests

### Integration Tests
Located in `test/Integration/FundMeTestIntegration.t.sol`:
- End-to-end funding and withdrawal flows
- User interaction scenarios
- Contract state verification

## Scripts

### DeployedFundme.s.sol
- Handles contract deployment
- Configures price feed addresses

### FundmeHelper.s.sol
- Network configuration management
- Price feed address selection
- Mock aggregator deployment for local testing

### Interactions.s.sol
- Contract interaction scripts
- Funding and withdrawal functionality

## Gas Optimization

The contract includes a gas-optimized withdrawal function (`cheaperWithdraw`) that:
- Reduces storage reads
- Optimizes loop operations
- Implements efficient memory usage

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Security

- The contract includes access control mechanisms
- Owner-only withdrawal functionality
- Secure fund management
- Comprehensive test coverage

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Chainlink](https://chain.link/) for price feed oracles
- [Foundry](https://book.getfoundry.sh/) for the development framework
- [Solmate](https://github.com/transmissions11/solmate) for gas optimization inspiration
