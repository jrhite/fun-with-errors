//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";

import "./CustomErrorContract.sol";

contract ErrorHandlingContract {
  CustomErrorContract private customErrorContract;
  address owner;

  constructor(address _customErrorContract) {
    owner = msg.sender;
    customErrorContract = CustomErrorContract(_customErrorContract);
  }

  function ownerOnly() public view returns (bool) {
    require(msg.sender == owner, "Only owner can call this function");
    
    return true;
  }

  function requireErrorHandlingFunction(uint x) public view returns (string memory) {
    try customErrorContract.requireExample(x) returns (bool success) {
      if (success) {
        return "There were no errors! Yay!";
      }

      return "Boo! There were errors";
    } catch Error(string memory errorReason) {
      return errorReason;
    } catch (bytes memory) {
      // if (keccak256(abi.encodeWithSignature("CustomError(uint, string)")) == keccak256(err)) {
      //   return "CustomError";
      // }

    }
  }

  function customErrorHandlingFunction() public view returns (string memory) {
    try customErrorContract.revertAsCustomErrorExample() {

      // no-op
      return "Should not get here";

    } catch Error(string memory revertReason) {

      return revertReason;

    } catch (bytes memory) {

      // if (keccak256(abi.encodeWithSignature("CustomError(uint, string)")) == keccak256(err)) {
      //   return "CustomError";
      // }

      //  low-level EVM error or CustomError
      return "Low-level EVM error or CustomError";
    }
  }
}
