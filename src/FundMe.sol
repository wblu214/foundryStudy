// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//constant 常量,immutable 可变量
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINI_USD = 1e18;

    address[] private s_funders;

    mapping(address funder => uint256 amountFunded)
        private s_addressToAmountFunded;

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
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // gas 37184
        // reset s_funders address and balance
        for (
            uint256 s_fundersIndex = 0;
            s_fundersIndex < s_funders.length;
            s_fundersIndex++
        ) {
            address funder = s_funders[s_fundersIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);
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

    /**
     * Getter Functions
     */

    /**
     * @notice Gets the amount that an address has funded
     *  @param fundingAddress the address of the funder
     *  @return the amount funded
     */
    function getAddressToAmountFunded(
        address fundingAddress
    ) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return I_OWBNER;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
