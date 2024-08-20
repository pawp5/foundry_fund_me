// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract interactionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        vm.deal(USER, STARTING_BALANCE); //give the user some ether ** 10 ether
    }

    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        // uint256 fundMeBalance = address(fundMe).balance;
        // uint256 amountFunded = fundFundMe.getFundAmount();
        // assertEq(amountFunded, fundMeBalance);

        uint256 amountFunded = fundMe.getAddressToAmountFunded(msg.sender);
        uint256 USER_SEND_VALUE = fundFundMe.getFundAmount();
        assertEq(amountFunded, USER_SEND_VALUE);
    }

    function testUserCanWithdraw() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
        // assertEq(address(fundMe).balance, 0);
    }
}