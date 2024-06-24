// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Position} from "src/perp/libraries/Position.sol";
import {PositionLibrary} from "src/perp/libraries/PositionLibrary.sol";

interface IPerpetual {
    /**
     * @notice Deposit the settlement token to the contract
     * @dev This function is a very simple function that replaces the LP function in a typical AMM perp.
     * @param _amount The amount of the settlement token to deposit
     */
    function deposit(uint256 _amount) external;

    /**
     * @notice Withdraw the settlement token from the contract
     * @dev This function is a very simple function that replaces the LP function in a typical AMM perp.
     * @param _amount The amount of the settlement token to withdraw
     */
    function withdraw(uint256 _amount) external;

    /**
     * @notice Open a position
     * @param _size The size of the position
     * @param _leverage The leverage of the position
     * @param _isLong The direction of the position
     */
    function openPosition(uint256 _size, uint256 _leverage, bool _isLong) external;

    /**
     * @notice Close a position
     * @param _isLong The direction of the position
     */
    function closePosition(bool _isLong) external;

    /**
     * @notice Liquidate a position
     * @param position The position to liquidate
     */
    function liquidatePosition(Position position) external;

    /**
     * @notice Get the position info
     * @param position The position to get the info
     */
    function getPositionInfo(Position position) external view returns (PositionLibrary.PositionData memory);
}
