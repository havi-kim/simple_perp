// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";

import {IPriceOracle} from "src/oracle/interfaces/IPriceOracle.sol";
import {SimplePriceOracle} from "src/oracle/SimplePriceOracle.sol";

contract PriceOracleTest is Test{
    IPriceOracle private priceOracle = new SimplePriceOracle();

    function test_price_oracle_set_price() external {
        // Arrange
        address token = address(0x1);
        uint price = 100;

        // Act
        priceOracle.setPrice(token, price);

        // Assert
        assertEq(priceOracle.getPrice(token), price, "invalid price");
    }
}
