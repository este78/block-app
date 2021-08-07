pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract BookList {
  uint public taskCount = 0;

  struct Book {
    uint id;
    string name;
    uint user_id;
  }

  mapping(uint => Book) public books;

  event BookCreated(
    uint id,
    string name
  );

  event BookUpdated(
    uint id,
    string name
  );

  function newBook(string memory _name, uint _user_id) public {
    books[taskCount] = Book(taskCount, _name, _user_id);
    taskCount++;
    emit BookCreated(taskCount, _name);
  }

  function editBook(uint _id, string memory _name, uint _user_id) public {
    books[_id] = Book(_id, _name, _user_id);
    emit BookUpdated(_id, _name);
  }

  function getAll() public view returns (Book[] memory){
    Book[] memory _books = new Book[](taskCount);
    for (uint i = 0; i < taskCount; i++) {
        _books[i] = books[i];
    }
    return _books;
  }

}

