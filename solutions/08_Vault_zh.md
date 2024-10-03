<div align="center">
<p align="left">(<a href="https://github.com/XuHugo/Ethernaut-Foundry-Solutions/tree/main/solutions">back</a>)</p>

<img src="../imgs/levels/8-vault.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 8 - Vault</strong></h1>

</div>
<br>

详细解读文章: [Ethernaut Foundry Solutions | Level 8 - Vault](https://blog.csdn.net/xq723310/)

## 目录

- [目录](#目录)
- [目标](#目标)
- [漏洞](#漏洞)
  - [Storage](#Storage)
  - [读取Storage](#读取Storage)
- [解答](#解答)
- [要点](#要点)

## 目标

要 unlock 这个合约账户，也就是要找到 password
<img src="../imgs/requirements/8-vault-requirements.webp" width="800px"/>

## 漏洞

我们需要理解EVM中，存储的布局以及原理(使用32字节大小的插槽)和JSON RPC函数`eth_getStorageAt`。

### Storage

EVM的数据都是存在32字节槽。第一个状态变量存储在槽位0。如果第一个变量存储完了，还有足够的字节，下一个变量也存储在slot 0，否则存储在slot 1，依此类推。

> 注意:像数组和字符串这样的动态类型是不同的，它们的工作方式不同。但这是另一个层面……

在Vault合约中，`locked` 是一个布尔值，使用1字节。slot 0有31字节未使用的存储空间。`password` 是一个bytes32，使用32个字节。由于插槽0中剩余的31个字节无法容纳它，因此它被存储在slot 1中。

### 读取Storage

`eth_getStorageAt` JSON RPC函数可用于读取合约在给定槽位的存储。

你可以使用web3相关的sdk，调用此方法；例如，web3.js读取slot 1的合约存储，你可以使用以下函数:

```javascript
web3.eth.getStorageAt(contractAddress, 1, (err, result) => {
  console.log(result);
});
```

我们使用Foundry, 可以使用cheatcodes中的load，如下:

```javascript
bytes32 password = vm.load(address(instance), bytes32(uint256(1)));
```

## 解答

因为我们知道密码存储在slot 1中，所以我们可以读取该slot的存储以找到密码，然后使用密码调用 `unlock` 函数来完成关卡。

```javascript
    bytes32 password = vm.load(address(instance), bytes32(uint256(1)));
    instance.unlock(password);

    assertEq(instance.locked(), false);
```

## 要点

- `private` 关键字意味着数据只能由合约本身访问，而不是对外界隐藏。
- 区块链上没有什么是私有的。一切都是公开的，任何人都可以阅读。

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
