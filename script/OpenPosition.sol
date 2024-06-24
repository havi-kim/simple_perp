// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import "src/mocks/MintFreeERC20.sol";
import "src/perp/SimplePerpetual.sol";
import "src/mocks/MockAccount.sol";

contract OpenPosition is Script {
    function run() public {
        address admin = vm.envOr("ADMIN", address(0));
        uint256 pk = vm.envOr("PK", uint256(0));

        vm.startBroadcast(pk);
        MockAccount[] memory accounts = new MockAccount[](10);

        SimplePerpetual perp = SimplePerpetual(address(0x8cE1bE8f66922BD08624a3a2552a07f5844FCa34));
        perp.setPrice(address(0x5b0CD59389546305AE4b6B8E368F071A8BA2B341), 60000e18);

        accounts[0] = MockAccount(address(0x996A7E3D2875995CF29aDE6CC4b6E233820560bF));
        accounts[1] = MockAccount(address(0xDEFa8085E69d9E3F58d209fB5c465A6193CED436));
        accounts[2] = MockAccount(address(0x6BEE2047CCc9A01D9C73DDe922DF87c292c1EfE4));
        accounts[3] = MockAccount(address(0x72ba08556CD796E31150e6c78B072AB233343326));
        accounts[4] = MockAccount(address(0x6DF039E3Cc6197815de0a28de35577243536BE32));
        accounts[5] = MockAccount(address(0xcb7c740a1409ea8317B84ef0cDE04924C96f0159));
        accounts[6] = MockAccount(address(0xA058B1F55AA870A0588A5242B4630aFB9FcE41Ed));
        accounts[7] = MockAccount(address(0xd7E83F7e0C5E51e6D8AB3C3AFA32A3E74b56F0De));
        accounts[8] = MockAccount(address(0x3848C66409Aa86674f4b362114D6e6B13BE957Fa));
        accounts[9] = MockAccount(address(0x67044246ff693d27b1CC9cf001d6B95730De629F));

        for (uint i = 0; i < 10; i++) {
            accounts[i].openPosition(1e18, 500, true);
            accounts[i].openPosition(1e18, 500, false);
        }

        vm.stopBroadcast();
    }
}
