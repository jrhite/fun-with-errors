const { expect } = require("chai");
const { ethers } = require("hardhat");

describe('ErrorHandlingContract', function () {
  let owner, nonOwner;

  let errorHandlingContract;

  before(async function () {
    [owner, nonOwner] = await hre.ethers.getSigners();

    const CustomErrorContract = await ethers.getContractFactory('CustomErrorContract');
    const customErrorContract = await CustomErrorContract.deploy();
    await customErrorContract.deployed();

    const ErrorHandlingContract = await hre.ethers.getContractFactory('ErrorHandlingContract');
    errorHandlingContract = await ErrorHandlingContract.deploy(
      customErrorContract.address
    );

    await errorHandlingContract.deployed();

    console.log(
      `\n\n\nCustomErrorContract deployed at address:\t${customErrorContract.address}`
    );

    console.log(
      `ErrorHandlingContract deployed at address:\t${errorHandlingContract.address}\n\n\n`
    );
  });

  it('ownerOnly() success case', async function () {
    expect(await errorHandlingContract.ownerOnly()).to.be.true;
  });

  it('ownerOnly() revert case', async function () {
    errorHandlingContract = errorHandlingContract.connect(nonOwner);

    await expect(errorHandlingContract.ownerOnly()).to.be.revertedWith(
      'Only owner can call this function'
    );

     errorHandlingContract = errorHandlingContract.connect(owner);
  });

  it('requireExample -- handles errors in success case', async function () {
    expect(
      await errorHandlingContract.requireErrorHandlingFunction(0)
    ).to.equal('There were no errors! Yay!');
  });

  it('requireExample -- handles errors in revert case', async function () {
    expect(
      await errorHandlingContract.requireErrorHandlingFunction(1)
    ).to.equal('This function can only be called with 0');
  });

  it('customErrorExample', async function () {
    expect(await errorHandlingContract.customErrorHandlingFunction()).to.equal(
      'Low-level EVM error or CustomError'
    );
  });

});
