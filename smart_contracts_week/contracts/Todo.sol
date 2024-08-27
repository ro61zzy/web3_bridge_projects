// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Todo {
    struct TodoItem {
        string title;
        string description;
        bool isDone;
    }

    TodoItem[] todos;

event TodoCreated();
 event TodoUpdated(uint256 indexed index);

    function createTodo(
        string memory _title,
        string memory _description
    ) external {
        //initialize a struct
        //default value of bool is false
        todos.push(TodoItem(_title, _description, false));

        //2nd way

emit TodoCreated();
    }

    function getTodos() external view returns (TodoItem[] memory) {
        return todos;
    }

    function getTodo(uint256 _index) external view returns (TodoItem memory) {
         require(_index <= todos.length - 1, "index out of bound");
        return todos[_index];
    }

    //updating notes
     function updateStatus(uint256 _index) external {
        require(_index <= todos.length - 1, "index out of bound");

        TodoItem storage td = todos[_index];

        td.isDone = !td.isDone;

        emit TodoUpdated(_index);
    }
}
