// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";

import {Position} from "src/perp/libraries/Position.sol";
import {PositionLibrary} from "src/perp/libraries/PositionLibrary.sol";

contract PositionLibraryTest is Test {
    using PositionLibrary for Position;

    // Sample data for test
    uint256 private ulPrice = 1000e18;
    uint256 private size = 100e18;
    uint256 private leverage = 10;

    function test_getPosition_long() external pure {
        // Arrange
        address owner = address(0x1);
        bool isLong = true;

        // Act
        Position position = PositionLibrary.getPosition(owner, isLong);

        // Assert
        assertEq(position.owner(), owner, "invalid owner");
        assertEq(position.isLong(), isLong, "invalid isLong");
    }

    function test_getPosition_short() external pure {
        // Arrange
        address owner = address(0x1);
        bool isLong = false;

        // Act
        Position position = PositionLibrary.getPosition(owner, isLong);

        // Assert
        assertEq(position.owner(), owner, "invalid owner");
        assertEq(position.isLong(), isLong, "invalid isLong");
    }

    function test_openPosition() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), true);

        // Act
        position.openPosition(ulPrice, size, leverage);

        // Assert
        PositionLibrary.PositionData memory positionData = position.copy();
        assertEq(positionData.openUlPrice, ulPrice, "invalid ulPrice");
        assertEq(positionData.size, size, "invalid size");
        assertEq(positionData.leverage, leverage, "invalid leverage");
    }

    function test_closePosition_no_pnL() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), true);
        position.openPosition(ulPrice, size, leverage);

        // Act
        uint256 closeSize = position.closePosition(ulPrice);

        // Assert
        PositionLibrary.PositionData memory positionData = position.copy();
        assertEq(positionData.size, 0, "invalid size");
        assertEq(closeSize, size, "invalid closeSize");
    }

    function test_closePosition_with_long_profit() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), true);
        position.openPosition(ulPrice, size, leverage);

        // Act
        uint256 closeSize = position.closePosition(ulPrice + 100e18);

        // Assert
        PositionLibrary.PositionData memory positionData = position.copy();
        assertEq(positionData.size, 0, "invalid size");
        assertEq(closeSize, size * 2, "invalid closeSize");
    }

    function test_closePosition_with_long_loss() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), true);
        position.openPosition(ulPrice, size, leverage);

        // Act
        uint256 closeSize = position.closePosition(ulPrice - 50e18);

        // Assert
        PositionLibrary.PositionData memory positionData = position.copy();
        assertEq(positionData.size, 0, "invalid size");
        assertEq(closeSize, size / 2, "invalid closeSize");
    }

    function test_closePosition_with_short_profit() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), false);
        position.openPosition(ulPrice, size, leverage);

        // Act
        uint256 closeSize = position.closePosition(ulPrice - 100e18);

        // Assert
        PositionLibrary.PositionData memory positionData = position.copy();
        assertEq(positionData.size, 0, "invalid size");
        assertEq(closeSize, size * 2, "invalid closeSize");
    }

    function test_closePosition_with_short_loss() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), false);
        position.openPosition(ulPrice, size, leverage);

        // Act
        uint256 closeSize = position.closePosition(ulPrice + 50e18);

        // Assert
        PositionLibrary.PositionData memory positionData = position.copy();
        assertEq(positionData.size, 0, "invalid size");
        assertEq(closeSize, size / 2, "invalid closeSize");
    }

    function test_closePosition_with_all_loss() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), true);
        position.openPosition(ulPrice, size, leverage);

        // Act
        uint256 closeSize = position.closePosition(ulPrice - 200e18);

        // Assert
        PositionLibrary.PositionData memory positionData = position.copy();
        assertEq(positionData.size, 0, "invalid size");
        assertEq(closeSize, 0, "invalid closeSize");
    }

    function test_liquidatePosition_long() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), true);
        position.openPosition(ulPrice, size, leverage);

        // Act
        position.liquidatePosition(ulPrice - 200e18);

        // Assert
        PositionLibrary.PositionData memory positionData = position.copy();
        assertEq(positionData.size, 0, "invalid size");
    }

    function test_liquidatePosition_short() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), false);
        position.openPosition(ulPrice, size, leverage);

        // Act
        position.liquidatePosition(ulPrice + 1000e18);

        // Assert
        PositionLibrary.PositionData memory positionData = position.copy();
        assertEq(positionData.size, 0, "invalid size");
    }

    function test_liquidatePosition_long_healthy() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), true);
        position.openPosition(ulPrice, size, leverage);

        // Act
        vm.expectRevert();
        position.liquidatePosition(ulPrice);
    }

    function test_liquidatePosition_short_healthy() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), false);
        position.openPosition(ulPrice, size, leverage);

        // Act
        vm.expectRevert();
        position.liquidatePosition(ulPrice);
    }

    function test_getLiquidationPrice_long() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), true);
        position.openPosition(ulPrice, size, leverage);

        // Act
        uint256 liqPrice = position.getLiquidationPrice();

        // Assert
        assertEq(liqPrice, ulPrice - (ulPrice / leverage), "invalid liqPrice");
    }

    function test_getLiquidationPrice_short() external {
        // Arrange
        Position position = PositionLibrary.getPosition(address(0x1), false);
        position.openPosition(ulPrice, size, leverage);

        // Act
        uint256 liqPrice = position.getLiquidationPrice();

        // Assert
        assertEq(liqPrice, ulPrice + (ulPrice / leverage), "invalid liqPrice");
    }
}
