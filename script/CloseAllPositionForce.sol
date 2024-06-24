// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import "src/perp/SimplePerpetual.sol";

contract CloseAllPositionForce is Script {
    function run() public {
        address admin = vm.envOr("ADMIN", address(0));
        uint256 pk = vm.envOr("PK", uint256(0));

        SimplePerpetual perp = SimplePerpetual(address(0x8cE1bE8f66922BD08624a3a2552a07f5844FCa34));

        uint length = perp.getOpenPositionList().length;
        console.log("Before close, Open position count: ", length);

        vm.startBroadcast(pk);
        perp.closeAllPositionForce();
        vm.stopBroadcast();

        length = perp.getOpenPositionList().length;
        console.log("After close, Open position count: ", length);
    }
}
