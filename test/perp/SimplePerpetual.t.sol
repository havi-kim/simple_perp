// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";

import {SimplePerpetual} from "src/perp/SimplePerpetual.sol";
import {MintFreeERC20} from "src/mocks/MintFreeERC20.sol";
import {IERC20} from "src/utils/interfaces/IERC20.sol";
import {Position} from "src/perp/libraries/Position.sol";
import {PositionLibrary} from "src/perp/libraries/PositionLibrary.sol";

contract SimplePerpetualTest is Test {
    SimplePerpetual private perp;
    IERC20 private settlementToken;
    address private underlyingToken;

    // Sample data for test
    uint256 private ulPrice = 1000e18;
    uint256 private size = 100e18;
    uint256 private leverage = 10;

    function setUp() external {
        // Mock
        underlyingToken = address(0x1);

        // Deploy
        settlementToken = new MintFreeERC20("TestToken", "TEST", 18);
        perp = new SimplePerpetual(address(settlementToken), underlyingToken);

        // Mint & Approve
        settlementToken.mint(address(this), 2e30);
        settlementToken.approve(address(perp), type(uint256).max);

        // Deposit
        perp.deposit(1e30);
    }

    function test_setPrice() external {
        // Arrange
        uint256 price = 100;

        // Act
        perp.setPrice(underlyingToken, price);

        // Assert
        assertEq(perp.getPrice(underlyingToken), price, "invalid price");
    }

    function test_openPosition() external {
        // Arrange
        perp.setPrice(underlyingToken, ulPrice);

        // Act
        uint256 balanceBefore = settlementToken.balanceOf(address(this));
        perp.openPosition(size, leverage, true);
        uint256 balanceAfter = settlementToken.balanceOf(address(this));

        // Assert
        assertEq(balanceBefore - size, balanceAfter, "invalid balance");

        Position position = PositionLibrary.getPosition(address(this), true);
        PositionLibrary.PositionData memory queriedData = perp.getPositionInfo(position);
        assertEq(queriedData.openUlPrice, ulPrice, "invalid ulPrice");
        assertEq(queriedData.size, size, "invalid size");
        assertEq(queriedData.leverage, leverage, "invalid leverage");
    }

    function test_closePosition() external {
        // Arrange
        perp.setPrice(underlyingToken, ulPrice);
        perp.openPosition(size, leverage, true);

        // Act
        uint256 balanceBefore = settlementToken.balanceOf(address(this));
        perp.closePosition(true);
        uint256 balanceAfter = settlementToken.balanceOf(address(this));

        // Assert
        assertEq(balanceBefore + size, balanceAfter, "invalid balance");

        Position position = PositionLibrary.getPosition(address(this), true);
        PositionLibrary.PositionData memory queriedData = perp.getPositionInfo(position);
        assertEq(queriedData.size, 0, "invalid size");
    }

    function test_liquidatePosition() external {
        // Arrange
        perp.setPrice(underlyingToken, ulPrice);
        perp.openPosition(size, leverage, true);
        perp.setPrice(underlyingToken, ulPrice - 200e18);

        // Act
        uint256 balanceBefore = settlementToken.balanceOf(address(this));
        perp.liquidatePosition(PositionLibrary.getPosition(address(this), true));
        uint256 balanceAfter = settlementToken.balanceOf(address(this));

        // Assert
        assertEq(balanceBefore, balanceAfter, "invalid balance");

        Position position = PositionLibrary.getPosition(address(this), true);
        PositionLibrary.PositionData memory queriedData = perp.getPositionInfo(position);
        assertEq(queriedData.size, 0, "invalid size");
    }
}
