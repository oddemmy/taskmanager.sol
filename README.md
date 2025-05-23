
# Decentralized Task Manager
A Solidity smart contract for managing tasks with ERC-20 token rewards, built to flex intermediate-to-advanced Solidity skills.

# Features
- Create tasks with descriptions and token rewards.
- Assign tasks to contributors and mark them complete.
- Rewards held in escrow and sent securely.
- Uses OpenZeppelin’s IERC20 for token integration and Ownable for admin control.
- Events log task creation, assignment, completion, and rewards.

# How It Works
- Users create tasks with `createTask`, locking tokens in escrow.
- Creators assign tasks with `assignTask` and complete them with `completeTask`.
- View details with `getTask`.
- Built in Remix IDE.

# Why It’s Awesome
- Shows structs, mappings, and events for task management.
- Uses secure token transfers with checks-effects-interactions.
- Auditable for token handling and access control bugs, great for security training.

# Setup
1. Clone this repo: `git clone https://github.com/oddemmy/Task-Manager`
2. Open `TaskManager.sol` in Remix IDE (remix.ethereum.org).
3. Import OpenZeppelin contracts for IERC20 and Ownable.

# Security Notes
- `onlyTaskCreator` modifier blocks unauthorized actions.
- Secure token transfers via OpenZeppelin’s IERC20.
- Ready for auditing token misuse or access control flaws.

# License
MIT
