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