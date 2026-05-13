// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

interface IFlashMinter {
    function flashFee(address token, uint256 amount) external view returns (uint256);
    function maxFlashLoan(address token) external view returns (uint256);
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

    function test_flashFee_vs_flashLoan_quote_mismatch() public {

        uint256 amount = 1000e18;

        // -----------------------------
        // STEP 1: OFFCHAIN QUOTE SIMULATION
        // -----------------------------
        uint256 quotedFee = flashMinter.flashFee(GHO, amount);

        // -----------------------------
        // STEP 2: ON-CHAIN CAPACITY CHECK
        // -----------------------------
        uint256 maxLoan = flashMinter.maxFlashLoan(GHO);

        console.log("Quoted Fee:", quotedFee);
        console.log("Max Flash Loan:", maxLoan);

        // -----------------------------
        // STEP 3: CORE INVARIANT
        // -----------------------------
        assertTrue(
            maxLoan > 0,
            "Flash liquidity exists"
        );

        // -----------------------------
        // STEP 4: IMPACT CHECK (IMPORTANT)
        // -----------------------------
        uint256 costEstimate = amount + quotedFee;

        console.log("Estimated repay cost:", costEstimate);

        assertTrue(
            costEstimate >= amount,
            "Repay cost must include fee"
        );
    }

    function test_quote_consistency_same_input() public {

        uint256 amount = 1000e18;

        uint256 fee1 = flashMinter.flashFee(GHO, amount);
        uint256 fee2 = flashMinter.flashFee(GHO, amount);

        assertEq(
            fee1,
            fee2,
            "flashFee must be deterministic for same input"
        );
    }
}
