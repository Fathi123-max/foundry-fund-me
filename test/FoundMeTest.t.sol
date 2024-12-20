//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTeat is Test {
    FundMe fundme;

    function setUp() external {
        fundme = new FundMe();
    }

    function testMunimumUSD() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwner() public view {
        assertEq(fundme.i_owner(), address(this));
    }

    function testContractVersion() public view {
        uint256 version = fundme.getVersion();

        assert(version == 4);
    }
}
