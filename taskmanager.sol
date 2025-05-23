// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TaskManager is Ownable {
    // Struct to store task details
    struct Task {
        string description;
        address creator;
        address assignee;
        bool completed;
        uint256 reward;
    }

    // State variables
    IERC20 public rewardToken; // ERC-20 token for rewards
    mapping(uint256 => Task) public tasks;
    uint256 public taskCount;

    // Events
    event TaskCreated(uint256 indexed taskId, address creator, string description, uint256 reward);
    event TaskAssigned(uint256 indexed taskId, address assignee);
    event TaskCompleted(uint256 indexed taskId, address assignee, uint256 reward);
    event RewardDistributed(uint256 indexed taskId, address assignee, uint256 reward);

    // Modifiers
    modifier taskExists(uint256 _taskId) {
        require(_taskId < taskCount, "Task does not exist");
        _;
    }

    modifier onlyTaskCreator(uint256 _taskId) {
        require(msg.sender == tasks[_taskId].creator, "Only task creator can perform this action");
        _;
    }

    constructor(address _rewardToken) Ownable(msg.sender) {
        rewardToken = IERC20(_rewardToken); // Set ERC-20 token address
    }

    // Create a new task
    function createTask(string memory _description, uint256 _reward) external {
        require(_reward > 0, "Reward must be greater than 0");
        require(rewardToken.allowance(msg.sender, address(this)) >= _reward, "Insufficient token allowance");

        tasks[taskCount] = Task({
            description: _description,
            creator: msg.sender,
            assignee: address(0),
            completed: false,
            reward: _reward
        });

        // Move tokens to contract for escrow
        rewardToken.transferFrom(msg.sender, address(this), _reward);

        emit TaskCreated(taskCount, msg.sender, _description, _reward);
        taskCount++;
    }

    // Assign a task to a contributor
    function assignTask(uint256 _taskId, address _assignee) external onlyTaskCreator(_taskId) taskExists(_taskId) {
        Task storage task = tasks[_taskId];
        require(task.assignee == address(0), "Task already assigned");
        require(!task.completed, "Task already completed");

        task.assignee = _assignee;
        emit TaskAssigned(_taskId, _assignee);
    }

    // Mark task as completed and send reward
    function completeTask(uint256 _taskId) external onlyTaskCreator(_taskId) taskExists(_taskId) {
        Task storage task = tasks[_taskId];
        require(task.assignee != address(0), "No assignee for task");
        require(!task.completed, "Task already completed");

        task.completed = true;
        rewardToken.transfer(task.assignee, task.reward);

        emit TaskCompleted(_taskId, task.assignee, task.reward);
        emit RewardDistributed(_taskId, task.assignee, task.reward);
    }

    // View task details
    function getTask(uint256 _taskId) external view taskExists(_taskId) returns (
        string memory description,
        address creator,
        address assignee,
        bool completed,
        uint256 reward
    ) {
        Task memory task = tasks[_taskId];
        return (task.description, task.creator, task.assignee, task.completed, task.reward);
    }
}
