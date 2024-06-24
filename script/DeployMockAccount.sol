// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import "src/mocks/MintFreeERC20.sol";
import "src/mocks/MockAccount.sol";
import "src/perp/interfaces/IPerpetual.sol";

contract DeployMockAccount is Script {
    function run() public {
        address admin = vm.envOr("ADMIN", address(0));
        uint256 pk = vm.envOr("PK", uint256(0));

        vm.startBroadcast(pk);

        IPerpetual perp = IPerpetual(address(0x8cE1bE8f66922BD08624a3a2552a07f5844FCa34));
        IERC20 TEST_STABLE = IERC20(address(0x31794d3aAF28fE070f2F70F69208728aD9504dfd));

        // Deploy
        for (uint i = 0; i < 10; i++) {
            MockAccount account = new MockAccount(address(perp), address(TEST_STABLE));
            TEST_STABLE.mint(address(account), 2e30);

            console.log("Account:", address(account));
        }

        vm.stopBroadcast();
    }
}
