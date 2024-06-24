The `SimplePerpetual` contract is used for testing BE and infra purposes only, so there's no need to check for security like access control or reentrancy.

**functions**:
1. **deposit**: This function allows users to deposit the settlement token into the contract. It's a very simple function that replaces the LP function in a typical AMM perp.
2. **withdraw**: This function allows users to withdraw the settlement token from the contract. It's a very simple function that replaces the LP function in a typical AMM perp.
3. **openPosition**: This function allows users to open a position. Users can specify the size, leverage, and direction of the position.
4. **closePosition**: This function allows users to close a position. Users need to specify the direction of the position.
5. **liquidatePosition**: This function allows users to liquidate a position. Users need to specify the position to be liquidated.
6. **setPrice**: This function allows users to set the price of the token. 
7. **getPositionInfo**: This function allows users to get information about a position. Users need to specify the position they want to get information about.
8. **getPrice**: This function allows users to get the price of the token.

**Installation**:
1. **Clone**
```
$ git clone https://github.com/havi-kim/simple_perp.git
$ cd simple_perp
```

2. **Install foundry**
```
$ curl -L https://foundry.paradigm.xyz | bash
$ foundryup
```

3. **Compile**
```
$ forge build
```

4. **Test**
```
$ forge test
```

5. **Run script**
```
PK=0x... forge script scripts/....sol --rpc-url http://... --broadcast --legacy
```

**Selectors**:
```
SimplePerpetual
+----------+------------------------------------------------------------+--------------------------------------------------------------------+
| Type     | Signature                                                  | Selector                                                           |
+============================================================================================================================================+
| Function | closeAllPositionForce()                                    | 0xafde20d7                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | closePosition(bool)                                        | 0x6671b6da                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | deposit(uint256)                                           | 0xb6b55f25                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | getOpenPositionList()                                      | 0x994ae984                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | getPositionInfo(bytes32)                                   | 0x5f458e51                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | getPrice(address)                                          | 0x41976e09                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | liquidatePosition(bytes32)                                 | 0xeaf7762c                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | openPosition(uint256,uint256,bool)                         | 0x1558c966                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | setPrice(address,uint256)                                  | 0x00e4768b                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | settlementToken()                                          | 0x7b9e618d                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | underlyingToken()                                          | 0x2495a599                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Function | withdraw(uint256)                                          | 0x2e1a7d4d                                                         |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Event    | PositionClose(bytes32,uint256,uint256,bool)                | 0x29d3517bb01203bde1070d3a1a54da0152ca63027db1792faee5ea877962840e |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Event    | PositionCloseForce(uint256)                                | 0x4488bc997a3ce32e900938e37a998b50389ba9342ce19e1b0b5cdaf880f2abdf |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Event    | PositionLiquidate(bytes32,uint256)                         | 0x6176ff70071eb12d900316e4f8fae97f36fb844e2322b7b39787fb265fe5df96 |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Event    | PositionOpen(bytes32,uint256,uint256,uint256,uint256,bool) | 0x1a05420985c54696c0e5d578b8c30bba6af49bafe697d23b048d56f0d7a7b7ab |
|----------+------------------------------------------------------------+--------------------------------------------------------------------|
| Event    | PriceSet(address,uint256)                                  | 0xf9a09e2869a1f88523f00504328d7965866201bafe501573db2e114e3375a086 |
+----------+------------------------------------------------------------+--------------------------------------------------------------------+
```