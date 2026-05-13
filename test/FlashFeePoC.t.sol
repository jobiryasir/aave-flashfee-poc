// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

interface IFlashMinter {
    function flashFee(address token, uint256 amount) external view returns (uint256);
}

contract FlashFeePoC is Test {

    address constant FLASH_MINTER =
        0xb639D208Bcf0589D54FaC24E655C79EC529762B8;

    address constant GHO =
        0x40d16fc024adac0f8a72337a9ff5c8d3a6c5b7e4;

    IFlashMinter flashMinter;

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("mainnet"));
        flashMinter = IFlashMinter(FLASH_MINTER);
    }

    function test_flashFee() public {

        vm.prank(address(0x1));
        uint256 feeA = flashMinter.flashFee(GHO, 1e18);

        vm.prank(address(0x2));
        uint256 feeB = flashMinter.flashFee(GHO, 1e18);

        assertTrue(feeA != feeB, "BUG: msg.sender dependency");
    }
}
