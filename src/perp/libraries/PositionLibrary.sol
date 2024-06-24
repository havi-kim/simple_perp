// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Position} from "./Position.sol";

/*
 * @title PositionLibrary
 * @notice A library to manage the position
 */
library PositionLibrary {
    struct PositionData {
        uint96 openUlPrice;
        uint96 size;
        uint32 leverage;
    }

    /**
     * @notice Open a position
     * @param _position The position to open
     * @param _ulPrice The underlying price
     * @param _size The size of the position
     * @param _leverage The leverage of the position
     */
    function open(Position _position, uint256 _ulPrice, uint256 _size, uint256 _leverage) internal {
        // 0. Get the storage slot of the position
        PositionData storage positionData = read(_position);

        // 1. Validate the params & position
        require(_size > 0, "Size must be greater than 0");
        require(_ulPrice > 0, "Price must be greater than 0");
        require(_leverage > 0, "Leverage must be greater than 0");
        require(_ulPrice < 1e28, "Price must be less than 10**28");
        require(_size < 1e28, "Size must be less than 10**28");
        require(_leverage < 1000, "Leverage must be less than 1000");
        require(positionData.size == 0, "Position already opened");

        // 2. Update the position
        positionData.openUlPrice = uint96(_ulPrice);
        positionData.size = uint96(_size);
        positionData.leverage = uint32(_leverage);
    }

    /**
     * @notice Close a position
     * @param _position The position to close
     * @param _ulPrice The underlying price
     * @return closeSize The size of the position after closing
     */
    function close(Position _position, uint256 _ulPrice) internal returns (uint256 closeSize) {
        // 0. Get the storage slot of the position
        PositionData storage data = read(_position);

        // 1. Validate the params & position
        require(data.size > 0, "Position not opened");

        // 2. Calculate the PnL
        uint256 pnlDelta;
        bool isProfit;
        if (_ulPrice > data.openUlPrice) {
            pnlDelta = data.leverage * data.size * (_ulPrice - data.openUlPrice) / data.openUlPrice;
            isProfit = isLong(_position);
        } else {
            pnlDelta = data.leverage * data.size * (data.openUlPrice - _ulPrice) / data.openUlPrice;
            isProfit = !isLong(_position);
        }

        // 3. Return the PnL
        if (isProfit) {
            closeSize = data.size + pnlDelta;
        } else if (data.size > pnlDelta) {
            closeSize = data.size - pnlDelta;
        } else {
            closeSize = 0;
        }

        // 4. Update the position
        data.size = 0;
    }

    /**
     * @notice Liquidate a position
     * @param _position The position to liquidate
     * @param _ulPrice The underlying price
     */
    function liquidate(Position _position, uint256 _ulPrice) internal {
        // 0. Get the storage slot of the position
        PositionData storage positionData = read(_position);

        // 1. Calculate the liquidation price
        uint256 liqPrice = getLiquidationPrice(_position);

        // 2. Validate the position
        require(positionData.size > 0, "Position not opened");
        require((_ulPrice < liqPrice) == isLong(_position), "Position is healthy");

        // 3. Close the position
        positionData.size = 0;
    }

    /**
     * @notice Close a position by force
     * @param _position The position to close
     */
    function closeForce(Position _position) internal returns (uint256 closeSize){
        // 0. Get the storage slot of the position
        PositionData storage positionData = read(_position);

        // 1. Close the position
        closeSize = positionData.size;
        positionData.size = 0;
    }

    /**
     * @notice Get the liquidation price of a position
     * @param _position The position to get the liquidation price
     */
    function getLiquidationPrice(Position _position) internal view returns (uint256 liqPrice) {
        // 0. Get the storage slot of the position
        PositionData storage positionData = read(_position);

        // 1. Validate the params & position
        require(positionData.size > 0, "Position not opened");

        // 2. Calculate the liquidation price
        uint256 leverage = positionData.leverage;
        uint256 openUlPrice = positionData.openUlPrice;
        if (isLong(_position)) {
            liqPrice = openUlPrice * (leverage - 1) / leverage;
        } else {
            liqPrice = openUlPrice * (leverage + 1) / leverage;
        }
    }

    /**
     * @notice Get the position key
     * @param _owner The owner of the position
     * @param _isLong The direction of the position
     */
    function getPosition(address _owner, bool _isLong) internal pure returns (Position position) {
        assembly {
            position := _owner
            if _isLong {
                // position = position + (1 << 255)
                position := add(position, shl(255, 1))
            }
        }
    }

    /**
     * @notice Get the owner of a position
     * @param _position The position to get the owner
     */
    function owner(Position _position) internal pure returns (address owner_) {
        assembly {
            owner_ := _position
        }
    }

    function isLong(Position _position) internal pure returns (bool) {
        return uint256(Position.unwrap(_position)) > type(uint160).max;
    }

    /**
     * @notice Copy the position data
     * @param _position The position to copy
     */
    function copy(Position _position) internal view returns (PositionData memory position) {
        position = read(_position);
    }

    /**
     * @notice Reqd the position data
     * @param _position The position to read
     */
    function read(Position _position) private pure returns (PositionData storage positionData) {
        assembly {
            positionData.slot := _position
        }
    }
}
