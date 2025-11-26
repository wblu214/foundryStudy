// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/deployFundMe.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function testDemo1() public view {
        assertEq(fundMe.MINI_USD(), 1e17);
    }

    function testDemo2() public view {
        console.log(fundMe.I_OWBNER());
        console.log(msg.sender);
        assertEq(fundMe.I_OWBNER(), msg.sender);
    }

    function testDemo3() public view {
        assertEq(fundMe.getVersion(), 4);
    }
}
