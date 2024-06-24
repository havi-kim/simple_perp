// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";

import {Position} from "src/perp/libraries/Position.sol";
import {OpenPositionList} from "src/perp/libraries/OpenPositionList.sol";

contract PositionLibraryTest is Test {
    function test_add_position() public {
        // Arrange
        Position position = Position.wrap(keccak256("position"));

        // Act
        OpenPositionList.add(position);

        // Assert
        assertEq(OpenPositionList.getPositionList().length, 1);
        assertTrue(OpenPositionList.getPositionList()[0] == position);
    }

    function test_remove_position() public {
        // Arrange
        Position position = Position.wrap(keccak256("position"));
        OpenPositionList.add(position);

        // Act
        OpenPositionList.remove(position);

        // Assert
        assertEq(OpenPositionList.getPositionList().length, 0);
    }
}
