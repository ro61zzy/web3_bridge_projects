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


    }

    function getTodos() external view returns (TodoItem[] memory) {}

    function getTodo(uint256 _index) external view returns (TodoItem memory) {}

    //updating notes
    function updateTodo(uint256 _index) external {}
}
