//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract CustomErrorContract {
    error CustomError(uint, string);

    function requireExample(uint x) external pure returns (bool) {
        require(x == 0, "This function can only be called with 0");
        
        return true;
    }

    function revertAsCustomErrorExample() external pure {
        revert CustomError(42, "This is a revert as a custom error");
    }
}
