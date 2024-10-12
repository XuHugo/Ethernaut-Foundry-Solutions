// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/18_MagicNumber.sol";

interface Solver {
    function whatIsTheMeaningOfLife() external view returns (bytes32);
}

contract MagicNumberTest is Test {
    MagicNum instance;
    Attack attack;
    address player1;
    address player2;

    function setUp() public {
        player1 = vm.addr(1);

        attack = new Attack();
        instance = new MagicNum();
    }

    function testattacker() public {
        address solver = attack.attack1();
        instance.setSolver(solver);
        assertEq(
            Solver(solver).whatIsTheMeaningOfLife(),
            0x000000000000000000000000000000000000000000000000000000000000002a
        );
        uint256 size;
        assembly {
            size := extcodesize(solver)
        }
        assertEq(size, 10);
    }
}

contract Attack is Test {
    function attack1() public returns (address) {
        address solver;
        bytes
            memory bytecode = hex"600a600c600039600a6000f3602a60805260206080f3";
        //uint len;
        assembly {
            //len := mload(bytecode)
            solver := create(0, add(bytecode, 0x20), mload(bytecode)) //add(bytecode, 0x20)
        }
        //console.log(">>>>>>>>>>>>>>>>gas:", len); //22
        return solver;
    }

    function attack2() public returns (address) {
        address solver;
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, shl(0x68, 0x69602A60005260206000F3600052600A6016F3))
            solver := create(0, ptr, 0x13)
        }
        return solver;
    }
}
