// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    mapping(uint256 chainId => NetWorkConfig) networkConfigs;

    struct NetWorkConfig {
        address priceFeedAddress; // ETH/USD price feed
        address otherPriceFeedAddress; // other price feed
    }

    function getActiveNetworkConfigByChainId(
        uint256 chainId
    ) public view returns (NetWorkConfig memory) {
        return networkConfigs[chainId];
    }

    constructor() {
        networkConfigs[11155111] = getSepoliaNetworkConfig();
        networkConfigs[1] = getMainNetworkConfig();
        networkConfigs[31337] = getAnvilNetworkConfig();
    }

    function getSepoliaNetworkConfig()
        internal
        pure
        returns (NetWorkConfig memory)
    {
        NetWorkConfig memory sepoliaNetworkConfig = NetWorkConfig({
            priceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306,
            otherPriceFeedAddress: 0x5147eA642CAEF7BD9c1265AadcA78f997AbB9649
        });
        return sepoliaNetworkConfig;
    }

    function getMainNetworkConfig()
        internal
        pure
        returns (NetWorkConfig memory)
    {
        NetWorkConfig memory mainNetworkConfig = NetWorkConfig({
            priceFeedAddress: 0x5147eA642CAEF7BD9c1265AadcA78f997AbB9649,
            otherPriceFeedAddress: 0x5147eA642CAEF7BD9c1265AadcA78f997AbB9649
        });
        return mainNetworkConfig;
    }

    function getAnvilNetworkConfig() internal returns (NetWorkConfig memory) {
        //1. Deploy mock contract
        //2. back mock address
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetWorkConfig memory anvilNetworkConfig = NetWorkConfig({
            priceFeedAddress: address(mockV3Aggregator),
            otherPriceFeedAddress: 0x5147eA642CAEF7BD9c1265AadcA78f997AbB9649
        });
        return anvilNetworkConfig;
    }
}
