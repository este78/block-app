pragma solidity ^0.8.6;
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
        return address(this).balance;
    }

    //Spin function
    function spin(address payable _player) external {
        require(msg.value == 1 ether, "You must pay 1 ETH per spin");
        uint256 numberDrawed = rand();
        if (isPrime(numberDrawed)){
            _player.transfer(3 ether);
        }
        else{
            _player.transfer(0 ether);
        }
    } 
    //https://stackoverflow.com/questions/40200089/number-prime-test-in-javascript
    //Check if number us prime. Prime numbers will receive a prize from the slot machine
    function isPrime(uint256 _numberDrawed) public returns(bool){
        uint256 numberDrawed = _numberDrawed;
        for(uint i = 2; i< numberDrawed; i++){
            if(numberDrawed % i == 0 ){
                return false;
            }
            return numberDrawed > 1;
        }
    }

/* Random Number Generator used to draw numbers
https://stackoverflow.com/questions/58188832/solidity-generate-unpredictable-random-number-that-does-not-depend-on-input*/
  function rand() public view returns(uint256){
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp + block.difficulty +
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +
            block.gaslimit + 
            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)) +
            block.number
        )));

        return (seed - ((seed / 100) * 100));
    }
}

  /*
    //in case I want to log the spins
      struct Spin {
        uint id;
        uint256 numberDrawed;
        bool winner;
    }
    mapping(uint => Spin) public spins;
    uint[] public spinsSpinned;
    
    event SpinCreated(
        uint id,
        string numberDrawed,
        bool winner,
        uint prize
    );


   // class example
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