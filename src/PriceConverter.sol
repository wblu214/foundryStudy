// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface aggregatorV3Interface
    ) internal view returns (uint256) {
        // 调取预言机合约，拿到价格信息
        // Address  0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI ✅
        (, int256 price, , , ) = aggregatorV3Interface.latestRoundData();
        // casting to 'uint256' is safe because Chainlink price feeds return positive integers
        // forge-lint: disable-next-line(unsafe-typecast)
        return uint256(price) * 1e10;
        // return uint256(price);
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface aggregatorV3Interface
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(aggregatorV3Interface);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion(
        AggregatorV3Interface aggregatorV3Interface
    ) internal view returns (uint256) {
        return aggregatorV3Interface.version();
    }

    function getUserWalletPrice() internal view returns (uint256) {
        return msg.sender.balance;
    }
}
