// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AreaCalculator {
    
    // Function to calculate the area of a triangle
    function calculateTriangleArea(uint256 base, uint256 height) public pure returns (uint256) {
        require(base > 0 && height > 0, "Base and height must be greater than zero");
        return (base * height) / 2;
    }

    // Function to calculate the area of a rectangle
    function calculateRectangleArea(uint256 length, uint256 width) public pure returns (uint256) {
        require(length > 0 && width > 0, "Length and width must be greater than zero");
        return length * width;
    }

  
}
