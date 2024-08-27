// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract studentPortal {

address public owner;

//struct contain student details
struct Student{
    string name;
    string email;
    string phoneNumber;
    string dateOfBirth;
    string lga;
    string country;
    string state;
}
//identify a student with phone number
 mapping(string => Student) private students;

//event for updating state, register, update, delete
   event StudentRegistered(string indexed phoneNumber);

//restrict to owner only
  modifier onlyOwner() {
        require(msg.sender == owner, "owner only can perform this action.");
        _;
    }

  constructor() {
        owner = msg.sender;
    }

//setter
     function registerStudent(
        string memory _name, 
        string memory _email, 
        string memory _phoneNumber,
        string memory _dateOfBirth, 
        string memory _lga, 
        string memory _country, 
        string memory _state
    ) public onlyOwner {
        students[_phoneNumber] = Student(_name, _email,_phoneNumber, _dateOfBirth, _lga, _country, _state);

        emit StudentRegistered(_phoneNumber);
    }

//getter
     function getStudent(string memory _phoneNumber) public view returns (
        string memory name, 
        string memory email, 
        string memory dateOfBirth, 
        string memory lga, 
        string memory country, 
        string memory state
    ) {
        Student memory student = students[_phoneNumber];
        return (student.name, student.email, student.dateOfBirth, student.lga, student.country, student.state);
    }

//updating


}
