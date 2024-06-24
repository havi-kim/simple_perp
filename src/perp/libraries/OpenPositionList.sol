// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Position} from "./Position.sol";

library OpenPositionList {
    bytes32 private constant _POSITION_LIST_STORAGE =
        keccak256("perp.storage.PositionList");

    struct Data {
        Position[] positions;
    }

    /**
     * @notice Add a position to the list
     * @param position The position to add
     */
    function add(Position position) internal {
        read().positions.push(position);
    }

    /**
     * @notice Remove a position from the list
     * @param position The position to remove
     */
    function remove(Position position) internal {
        Data storage self = read();
        for (uint256 i = 0; i < self.positions.length; i++) {
            // This is not efficient in terms of gas, but it's fine for this example
            if (self.positions[i] == position) {
                self.positions[i] = self.positions[self.positions.length - 1];
                self.positions.pop();
                break;
            }
        }
    }

    /**
     * @notice Get the list of positions
     * @return The list of positions
     */
    function getPositionList() internal view returns (Position[] memory) {
        return read().positions;
    }

    /**
     * @notice Get slot of the position list
     */
    function read() private pure returns (Data storage data) {
        bytes32 location = _POSITION_LIST_STORAGE;
        assembly {
            data.slot := location
        }
    }
}
