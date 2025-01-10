// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

//  integration test for fun fundme contract

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

/// @notice This contract facilitates funding the most recently deployed FundMe contract
/// @dev It sends a fixed amount of ether to the FundMe contract via the fund function
contract FundFundMe is Script {
    uint256 constant SEND_VALUE = .1 ether;

    function fundFundMe(address mostResentDeployedFundMe) public {
        vm.startBroadcast();
        FundMe(payable(mostResentDeployedFundMe)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();

        console.log("FundFundMe with %s eth", SEND_VALUE);
    }

    function run() external {
        address mostResentDeployedFundMe = DevOpsTools
            .get_most_recent_deployment("FundMe", block.chainid);

        fundFundMe(mostResentDeployedFundMe);
    }
}

/// @notice integration test for withdraw
/// @dev this script will withdraw from the most recently deployed FundMe contract
///

// integration test for withdraw
contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance!");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(mostRecentlyDeployed);
    }
}
