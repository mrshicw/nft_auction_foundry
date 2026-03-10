pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";

contract MyTest is Test {
    function testWrap() public {
        uint256 startTime = block.timestamp;
        vm.warp(block.timestamp + 1000);

        assertEq(block.timestamp, startTime + 1000);
    }
}