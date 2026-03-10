# 
## warp
### 描述
- 设置block.timestamp为指定值。

```solidity
function testWarp() public {
    vm.warp(1641070800);
    assertEq(block.timestamp, 1641070800);
}
```
### 陷阱: 
- 使用--via-ir编译时，直接访问block.timestamp可能会被优化为常量值。请改用vm.getBlockTimestamp()其他方法，以确保在数据变形后获取当前值。

### 相关作弊码: 
- getBlockTimestamp- 获取当前块时间戳（避免 IR 优化问题）
- roll- 套block.number

### 参见:
- skip- 时间快进
- rewind- 倒转时间

## roll
### 描述
- 设置block.number为指定值。
```solidity
function testRoll() public {
    vm.roll(100);
    assertEq(block.number, 100);
}

function testFee() public {
    vm.fee(25 gwei);
    assertEq(block.basefee, 25 gwei);
}

function testGetBlockTimestamp() public {
    assertEq(vm.getBlockTimestamp(), 1, "timestamp should be 1");
    vm.warp(10);
    assertEq(vm.getBlockTimestamp(), 10, "warp failed");
}

function testGetBlockNumber() public {
    uint256 height = vm.getBlockNumber();
    assertEq(height, block.number);
    vm.roll(10);
    assertEq(vm.getBlockNumber(), 10);
}

function testDifficulty() public {
    vm.difficulty(25);
    assertEq(block.difficulty, 25);
}

function testPrevrandao() public {
    vm.prevrandao(bytes32(uint256(42)));
    assertEq(block.prevrandao, 42);
}








```

```bash
forge init --force --no-git
```
```bash

```