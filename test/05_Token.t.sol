// // SPDX-License-Identifier: Unlicense
// pragma solidity ^0.6.0;

// import "forge-std/Test.sol";
// import "src/05_Token.sol";

// contract TokenTest is Test {
//     Token instance;
//     address player1;
//     address player2;

//     function setUp() public {
//         player1 = vm.addr(1);
//         instance = new Token(10000);
//         instance.transfer(player1, 20);
//         player2 = vm.addr(2);
//     }

//     function testattacker() public {
//         vm.startPrank(player2);
//         instance.transfer(player2, 21);
//         vm.stopPrank();
//     }
// }
