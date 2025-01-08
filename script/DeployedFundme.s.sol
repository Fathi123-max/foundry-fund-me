// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {FundmeHelper} from "../script/FundmeHelper.s.sol";

contract DeployedFundme is Script {
    function run() external returns (FundMe priceFeedBackAdress) {
        FundmeHelper helper = new FundmeHelper();

        address priceFeed = helper.activeConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
