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

    // Function to calculate the area of a square
    function calculateSquareArea(uint256 side) public pure returns (uint256) {
        require(side > 0, "Side must be greater than zero");
        return side * side;
    }
}


// Deployer: 0xF4B71887d3988Cb1f9D7daA4F16112e0C7DAb8E8
// Deployed to: 0x75a0a4a2275d84c02A3F1cf232874e7fd3489B2c
// Transaction hash: 0x7ff0605d33ba17309cfd20a257967536a55caa24bb47c9e03f297201f89021e0