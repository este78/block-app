pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract TodoList {
  uint public taskCount = 0;

  struct Task {
    uint id;
    string content;
    bool completed;
  }

  mapping(uint => Task) public tasks;

  event TaskCreated(
    uint id,
    string content,
    bool completed
  );

  event TaskCompleted(
    uint id,
    bool completed
  );
  
  event TaskUpdated(
    uint id,
    string content,
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
  }


}

