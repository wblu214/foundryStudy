// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testDemo1() public view {
        assertEq(fundMe.MINI_USD(), 1e17);
    }

    function testDemo2() public view {
        console.log(fundMe.I_OWBNER());
        console.log(msg.sender);
        assertEq(fundMe.I_OWBNER(), address(this));
    }
}
