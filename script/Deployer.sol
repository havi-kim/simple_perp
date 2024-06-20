// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import "src/mocks/MintFreeERC20.sol";
import "src/perp/SimplePerpetual.sol";

contract Deployer is Script {
    function run() public {
        address admin = vm.envOr("ADMIN", address(0));
        uint256 pk = vm.envOr("PK", uint256(0));

        vm.startBroadcast(pk);

        // Mock
        address underlyingToken = address(0x1);

        // Deploy
        IERC20 TEST_BTC = new MintFreeERC20("Bitcoin", "BTC", 18);
        IERC20 TEST_STABLE = new MintFreeERC20("USD", "USD", 18);

        SimplePerpetual perp = new SimplePerpetual(address(TEST_STABLE), address(TEST_BTC));

        // Mint & Approve
        TEST_STABLE.mint(admin, 2e30);
        TEST_STABLE.approve(address(perp), type(uint256).max);

        // Deposit
        perp.deposit(1e30);

        console.log("Perpetual address:", address(perp));
        console.log("Test BTC address:", address(TEST_BTC));
        console.log("Test Stable address:", address(TEST_STABLE));

        vm.stopBroadcast();
    }
}
