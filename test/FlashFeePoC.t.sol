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
        0x40d16Fc024aDac0f8a72337A9ff5c8d3a6c5b7e4;  
  
    IFlashMinter flashMinter;  
  
    function setUp() public {  
        vm.createSelectFork(vm.rpcUrl("mainnet"));  
        flashMinter = IFlashMinter(FLASH_MINTER);  
    }  
  
    function test_flashFee_quote_consistency() public {  
  
        uint256 amount = 1000e18;  
  
        // simulate two different execution contexts  
        address callerA = address(0xAA);  
        address callerB = address(0xBB);  
  
        vm.prank(callerA);  
        uint256 feeA = flashMinter.flashFee(GHO, amount);  
  
        vm.prank(callerB);  
        uint256 feeB = flashMinter.flashFee(GHO, amount);  
  
        console.log("Fee A:", feeA);  
        console.log("Fee B:", feeB);  
  
        // core invariant check  
        assertTrue(  
            feeA == feeB,  
            "flashFee should be deterministic for same input (token, amount)"  
        );  
    }  
}  
  
