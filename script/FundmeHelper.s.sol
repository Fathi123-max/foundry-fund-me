// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract FundmeHelper is Script {
    NetworkConfig public activeConfig;
    //uint8 _decimals, int256 _initialAnswer
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8;
    //model
    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeConfig = getSepoliaFeedAccess();
        } else if (block.chainid == 1) {
            activeConfig = getEthFeedAccess();
        } else {
            activeConfig = getOrCreateAnvilFeedAccess();
        }
    }

    function getSepoliaFeedAccess() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig(
            address(0x694AA1769357215DE4FAC081bf1f309aDC325306)
        );
        return config;
    }

    function getEthFeedAccess() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig(
            address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419)
        );
        return config;
    }

    function getOrCreateAnvilFeedAccess()
        public
        returns (NetworkConfig memory)
    {
        MockV3Aggregator priceFeed;

        if (activeConfig.priceFeed != address(0)) {
            return activeConfig;
        }

        vm.startBroadcast();
        priceFeed = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
        vm.stopBroadcast();

        NetworkConfig memory config = NetworkConfig({
            priceFeed: address(priceFeed)
        });
        return config;
    }
}
