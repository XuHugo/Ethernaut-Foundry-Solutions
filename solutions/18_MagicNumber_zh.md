<div align="center">
<p align="left">(<a href="https://github.com/XuHugo/Ethernaut-Foundry-Solutions/tree/main/solutions">back</a>)</p>

<img src="../imgs/levels/18-magicNumber.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 18 - Magic Number</strong></h1>

</div>
<br>

详细解读文章: [Ethernaut Foundry Solutions | Level 18 - Magic Number](https://blog.csdn.net/xq723310/)

## 目录

- [目录](#目录)
- [目标](#目标)
- [漏洞](#漏洞)
- [解答](#解答)
- [要点](#要点)

## 目标

要求写一个合约，字节码不超过 10 个字节，在调用 whatIsTheMeaningOfLife() 时返回 42
<img src="../imgs/requirements/18-magicNumber-requirements.webp" width="800px"/>

## 漏洞

好了，这里比之前的水平要高级得多。这个级别虽然看起来很简单，但需要深入了解EVM操作码、堆栈如何工作、合约创建代码和运行时代码。

如果没有关卡的限制，通常的写法如下，但这样不能过关:

```javascript
contract Solver {
    function whatIsTheMeaningOfLife() public pure returns (uint256) {
        return 42;
    }
}
```
这是因为solidity是一种高级语言，它为我们实现了许多“内置”特性和检查。换句话说，它转换成汇编之后，肯定是超过10个字节的，无法完成关卡。

因此，我们需要用汇编编写合约。我们需要关注一下两点:

- 合约的创建部署;
- 他的返回值是42.

在合约的字节码中，分为两部分:

- <b>creation bytecode</b> 负责合约的部署;运行初始化函数，生成合约地址，返回`runtime bytecode`.
- <b>runtime bytecode</b> 负责合约正常调用，会持久的存储在链上.

由于合约`creation bytecode`包含初始化代码和合约`runtime bytecode`，并按顺序连接。所以我们先看看 `runtime bytecode` 是怎么回事，然后再组合`creation bytecode`.
创建字节码是部署契约时执行的第一件事。它负责部署合约并返回运行时字节码。这就是为什么我们将从运行时字节码开始。

### Runtime bytecode

他的功能和简单，就是存储42，然后返回
The absolute minimal setup for this contract to return the number 42 would be the following:

1. Store the number 42 in memory;
2. Return the number 42.

In raw bytecode, we can write it like this:

1. Using `MSTORE` to store the number 42 in memory: `mstore(pointer, value)`

| BYTECODE | OPCODE    | VALUE | COMMENT                          |
| -------- | --------- | ----- | -------------------------------- |
| 602a     | 60 PUSH1  | 0x2a  | 42 is 0x2a in hexadecimal        |
| 6080     | 60 PUSH1  | 80    | Memory pointer 0x80              |
| 52       | 52 MSTORE |       | Store 42 at memory position 0x80 |

2. Using `RETURN` to return the number 42 from memory: `return(pointer, size)`

| BYTECODE | OPCODE    | VALUE | COMMENT                                  |
| -------- | --------- | ----- | ---------------------------------------- |
| 6020     | 60 PUSH1  | 0x20  | 32 bytes in hexadecimal                  |
| 6080     | 60 PUSH1  | 80    | Memory pointer 0x80                      |
| f3       | f3 RETURN |       | Return 32 bytes from memory pointer 0x80 |

So here is our full runtime bytecode (smart contract code): `602a60805260206080f3`.
Now, we need to handle the creation code, so we can deploy our contract.

### Creation bytecode

Again, let's start with the absolute minimum we'll need to deploy our contract:

1. Store the runtime bytecode in memory;
2. Return the runtime bytecode.

In raw bytecode, we can write it like this:

1. Using `CODECOPY` to store the runtime bytecode in memory: `codecopy(value, position, destination)`

| BYTECODE | OPCODE      | VALUE | COMMENT                                                                                              |
| -------- | ----------- | ----- | ---------------------------------------------------------------------------------------------------- |
| 600a     | 60 PUSH1    | 0a    | Push 10 bytes (runtime code size)                                                                    |
| 600c     | 60 PUSH1    | 0c    | Copy from memory position at index 12 (initialization code takes 12 bytes, runtime comes after that) |
| 6000     | 60 PUSH1    | 00    | Paste to memory slot 0                                                                               |
| 39       | 39 CODECOPY |       | Store runtime code at memory slot 0                                                                  |

2. Using `RETURN` to return the 10 bytes runtime bytecode from memory starting at offset 22: `return(pointer, size)`

| BYTECODE | OPCODE    | VALUE | COMMENT                               |
| -------- | --------- | ----- | ------------------------------------- |
| 600a     | 60 PUSH1  | 0a    | 10 bytes in hexadecimal               |
| 6000     | 60 PUSH1  | 00    | Memory pointer 0                      |
| f3       | f3 RETURN |       | Return 10 bytes from memory pointer 0 |

Here is the full creation/deployment bytecode: `600a600c600039600a6000f3`.

And concatenating the two and adding `0x` in front, we get the full contract bytecode: `0x600a600c600039600a6000f3602a60805260206080f3`.

## 解答

Now that we have our raw bytecode ready, we can deploy the contract.

### In the browser's console

```javascript
const receipt = await web3.eth.sendTransaction({
  from: player,
  data: "0x600a600c600039600a6000f3602a60805260206080f3",
});
await contract.setSolver(receipt.contractAddress);
```

If you want to test it, you can use the following interface in Remix:

```javascript
interface IMeaningOfLife {
  function whatIsTheMeaningOfLife() external view returns (uint256);
}
```

### With Foundry using `forge`:

You can use the following command:

```bash
forge script script/18_MagicNumber.s.sol:PoC --rpc-url sepolia --broadcast --watch
```

And that's it! We have successfully deployed the contract and solved the level.

## 要点

- How the EVM and opcodes work at a low level.
- From low level to high level: Bytecode > Yul/Assembly > Solidity.

## Reference

- EVM opcodes: https://www.evm.codes/
- Simple bytecode contract: https://www.youtube.com/watch?v=0qQUhsPafJc

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
