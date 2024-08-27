// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Todo {
    struct TodoItem {
        string title;
        string description;
        bool isDone;
    }

    TodoItem[] todos;

    function createTodo(
        string memory _title,
        string memory _description
    ) external {
        //initialize a struct
        //default value of bool is false
        todos.push(TodoItem(_title, _description, false));

        //2nd way


    }

    function getTodos() external view returns (TodoItem[] memory) {
        return todos;
    }

    function getTodo(uint256 _index) external view returns (TodoItem memory) {
        
        return todos[_index];
    }

    //updating notes
    function updateTodo(uint256 _index) external {}
}
