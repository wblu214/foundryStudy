// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//constant 常量,immutable 可变量
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINI_USD = 1e17;

    address[] public funders;

    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    address public immutable I_OWBNER;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeedAddress) {
        I_OWBNER = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        //gas 110661
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINI_USD,
            "didn't send enough ETH"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // gas 37184
        // reset funders address and balance
        for (
            uint256 fundersIndex = 0;
            fundersIndex < funders.length;
            fundersIndex++
        ) {
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        (bool callSuccessful, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccessful, "Call Failed !!!");
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        _onlyOWner();
        _;
    }

    function _onlyOWner() internal view {
        require(msg.sender == I_OWBNER, "Must be Owner !!");
    }
}
