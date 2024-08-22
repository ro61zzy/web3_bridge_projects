// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AreaCalculator {
    
    // Function to calculate the area of a triangle
    function calculateTriangleArea(uint256 base, uint256 height) public pure returns (uint256) {
        require(base > 0 && height > 0, "Base and height must be greater than zero");
        return (base * height) / 2;
    }

}
