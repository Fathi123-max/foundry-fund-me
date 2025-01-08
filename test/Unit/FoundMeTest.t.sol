//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployedFundme} from "../../script/DeployedFundme.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address alice = makeAddr("alice");
    uint256 constant SEND_VALUE = .1 ether;
    uint256 constant STARTING_BALANCE = 9 ether;

    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployedFundme deployedFundme = new DeployedFundme();

        fundMe = deployedFundme.run();
        vm.deal(alice, STARTING_BALANCE);
    }

    function testMunimumUSD() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwner() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testContractVersion() public view {
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        }
    }

    // function testFundRevitWithoutEnoughEth() public {
    //     vm.expectRevert();
    //     fundMe.fund{value: 9 ether}();
    // }

    function testFundUpdatesFundDataStructure() public {
        console.log("Contract address: ", address(fundMe));
        console.log("Alice's address: ", alice);
        console.log("Sender's address: ", msg.sender);

        vm.prank(alice);

        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(alice);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testFunderAddedToFunders() public {
        vm.prank(alice);

        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, alice);
    }

    /**
     * @dev This modifier is used to simulate a user funding the contract.
     *      It will use the `alice` address to fund the contract with `SEND_VALUE` amount of ether.
     *      It will then execute the code inside the test function.
     */

    function testOwnerOnlyCanWithdraw() public funded {
        vm.prank(alice);
        vm.expectRevert();
        fundMe.withdraw();
    }

    //testWithdrow

    function testWithdrawWithSingleFunder() public funded {
        //arrange
        //alice balance

        // uint256 startAliceBalance = alice.balance; //10 eth - 0.1 eth
        uint256 startOwnerBalance = fundMe.getOwner().balance; //anvil main eth
        uint256 startContractBalance = address(fundMe).balance; // 0.1 eth

        //to calculate gas_price ==> warb act
        //calculate gas price
        vm.txGasPrice(GAS_PRICE);
        uint256 gasStart = gasleft();
        //start act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw(); // from contract to owner
        // end act
        uint256 gasEnd = gasleft();

        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;

        //console price used
        console.log("Withdraw consumed: %d gas", gasUsed);

        //assert
        // uint256 endtAliceBalance = alice.balance; //10 eth - 0.1 eth
        uint256 endingOwnerBalance = fundMe.getOwner().balance; // anvil main eth + 0.1 eth
        uint256 endingContractBalance = address(fundMe).balance; //0 eth

        assertEq(endingContractBalance, 0);
        assertEq(startOwnerBalance + startContractBalance, endingOwnerBalance);
    }

    function testWithdrawWithMutibaleFunder() public funded {
        //arrange

        //number of funders = 10
        // start index of funder = 0
        // we will use uint160 becouse we will convert uint to addresses for funders
        uint160 numberofFunders = 11;
        uint160 startIndex = 1;
        // console owner balance
        console.log("Start Owner balance: ", fundMe.getOwner().balance);
        for (uint160 index = startIndex; index < numberofFunders; index++) {
            //create funders adresses with initial balance
            hoax(address(index), STARTING_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }
        // now we have 10 funders with 0.1 eth each

        // initial balance of owner and contract

        uint256 startOwnerBalance = fundMe.getOwner().balance; // anvil main eth
        uint256 startContractBalance = address(fundMe).balance; // 0.1 * 10  eth

        // act

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // assert

        // ending balance of owner and contract
        uint256 endingOwnerBalance = fundMe.getOwner().balance; // anvil main eth + 0.1 * 10 eth
        uint256 endingContractBalance = address(fundMe).balance; //0 eth

        assertEq(endingContractBalance, 0);
        assertEq(startOwnerBalance + startContractBalance, endingOwnerBalance);
        // console owner balance
        console.log("End Owner balance: ", fundMe.getOwner().balance);

        // assert(
        //     ((numberofFunders + 1) * SEND_VALUE) ==
        //         (fundMe.getOwner().balance - startOwnerBalance)
        // );
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            // we get hoax from stdcheats
            // prank + deal
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
        assert(
            (numberOfFunders + 1) * SEND_VALUE ==
                fundMe.getOwner().balance - startingOwnerBalance
        );
    }

    modifier funded() {
        vm.prank(alice);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }
}
