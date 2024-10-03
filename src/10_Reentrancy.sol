// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import 'openzeppelin-contracts-06/math/SafeMath.sol';
import "src/lib/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;
    mapping(address => uint) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            // because we use version ^8.0.0,
            // so this part will revert panic: arithmetic underflow or overflow
            // Let's annotate this part
            // balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}
