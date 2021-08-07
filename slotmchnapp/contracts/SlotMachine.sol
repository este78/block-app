pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract SlotMachine {
    // Declare state variables of the contract
    address payable owner;

    //constructor set ownership of the slot machine
    constructor() public{
        owner = msg.sender;
    } 

    //Gets the balance of the slot machine in wei
    function slotBalance() public returns(uint256){
        require (msg.sender == owner, "You do not have access to this feature");
        return this.balance;
    }

    function isPrime() public returns(bool){}

/* Random Number Generator
https://stackoverflow.com/questions/58188832/solidity-generate-unpredictable-random-number-that-does-not-depend-on-input*/
  function rand() public view returns(uint256){
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp + block.difficulty +
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +
            block.gaslimit + 
            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)) +
            block.number
        )));

        return (seed - ((seed / 1000) * 1000));
    }
}

  /*
  uint public roundCount = 0;

  struct Round {
    uint id;
    string content;
    bool winner;
  }

  mapping(uint => Round) public rounds;

  event RoundCreated(
    uint id,
    string content,
    bool winner
  );

  event RoundWon(
    uint id,
    bool completed
  );
  
  function createTask(string memory _content) public {
    tasks[taskCount] = Task(taskCount, _content, false);
    taskCount ++;
    emit TaskCreated(taskCount, _content, false);
  }

  function toggleCompleted(uint _id) public {
    Task memory _task = tasks[_id];
    _task.completed = !_task.completed;
    tasks[_id] = _task;
    emit TaskCompleted(_id, _task.completed);
  }
  
  
  function getAll() public view returns (Task[] memory){
    Task[] memory todos = new Task[](taskCount);
    for (uint i = 0; i < taskCount; i++) {
        todos[i] = tasks[i];
    }
    return todos;
  }*/