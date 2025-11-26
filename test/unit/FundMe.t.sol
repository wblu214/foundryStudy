// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/deployFundMe.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address public USER = makeAddr("Alice");
    uint256 constant SEND_VALUE = 1 ether; //10000000000000000

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
        vm.deal(address(USER), 10 ether);
    }

    function testDemo1() public view {
        assertEq(fundMe.MINI_USD(), 1e18);
    }

    function testDemo2() public view {
        console.log(fundMe.I_OWBNER());
        console.log(msg.sender);
        assertEq(fundMe.I_OWBNER(), msg.sender);
    }

    function testDemo3() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailWithoutEnoughETH() public {
        vm.expectRevert(); //预期回滚
        fundMe.fund(); // set 0 value
    }

    function testFundUpdateFundDataStructure() public {
        vm.prank(USER); // the next TX(事务) will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testFundMeFundersToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        console.log("Contract Owner Address is ", fundMe.getOwner());

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawBySingleFunder() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        console.log("startingOwnerBalance is ", startingOwnerBalance);
        console.log("startingContractBalance is ", startingContractBalance);

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endOwnerBalance = fundMe.getOwner().balance;
        uint256 endContractBalance = address(fundMe).balance;

        console.log("endOwnerBalance is ", endOwnerBalance);
        console.log("endContractBalance is ", endContractBalance);

        assertEq(endContractBalance, 0);
        assertEq(
            endOwnerBalance + endContractBalance,
            startingOwnerBalance + startingContractBalance
        );
    }

    // function testWithDrawByTenFunders() public funded {
    //     for (uint256 i = 1; i < 10; i++) {
    //         // vm.prank + vm.deal = hoax //下一个操作强制为hoax的地址
    //         address funder = makeAddr(i);
    //         hoax(funder, SEND_VALUE);
    //         fundMe.fund{value: SEND_VALUE}();
    //     }

    //     uint256 startingOwnerBalance = fundMe.getOwner().balance;
    //     uint256 startingContractBalance = address(fundMe).balance;

    //     console.log("startingOwnerBalance is ", startingOwnerBalance);
    //     console.log("startingContractBalance is ", startingContractBalance);

    //     vm.prank(fundMe.getOwner());
    //     fundMe.withdraw();
    //     vm.stopPrank();

    //     assertEq(address(fundMe).balance, 0);
    //     assertEq(
    //         startingContractBalance + startingOwnerBalance ==
    //             fundMe.getOwner().balance
    //     );
    // }
}
