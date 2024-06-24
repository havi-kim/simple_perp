// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "src/utils/interfaces/IERC20.sol";
import {Position} from "src/perp/libraries/Position.sol";
import {PositionLibrary} from "src/perp/libraries/PositionLibrary.sol";
import {SimplePriceOracle} from "../oracle/SimplePriceOracle.sol";
import {IPerpetual} from "./interfaces/IPerpetual.sol";
import {OpenPositionList} from "src/perp/libraries/OpenPositionList.sol";

/**
 * @title SimplePerpetual
 * @notice A simple perpetual contract
 *    @dev This contract has a few functions to manage the perpetual contract.
 *         This is for testing purposes only. So no need to check access control & reentrancy.
 */
contract SimplePerpetual is IPerpetual, SimplePriceOracle {
    using PositionLibrary for Position;

    event PositionOpen(
        Position position, uint256 ulPrice, uint256 size, uint256 leverage, uint256 liqPrice, bool isLong
    );
    event PositionClose(Position position, uint256 ulPrice, uint256 size, bool isLong);
    event PositionLiquidate(Position position, uint256 ulPrice);
    event PositionCloseForce(uint256 size);

    IERC20 public immutable settlementToken;
    IERC20 public immutable underlyingToken;

    constructor(address _settlementToken, address _underlyingToken) {
        settlementToken = IERC20(_settlementToken);
        underlyingToken = IERC20(_underlyingToken);
    }

    /**
     * @notice Deposit the settlement token to the contract
     * @dev This function is a very simple function that replaces the LP function in a typical AMM perp.
     * @param _amount The amount of the settlement token to deposit
     */
    function deposit(uint256 _amount) external override {
        settlementToken.transferFrom(msg.sender, address(this), _amount);
    }

    /**
     * @notice Withdraw the settlement token from the contract
     * @dev This function is a very simple function that replaces the LP function in a typical AMM perp.
     * @param _amount The amount of the settlement token to withdraw
     */
    function withdraw(uint256 _amount) external override {
        settlementToken.transfer(msg.sender, _amount);
    }

    /**
     * @notice Open a position
     * @param _size The size of the position
     * @param _leverage The leverage of the position
     * @param _isLong The direction of the position
     */
    function openPosition(uint256 _size, uint256 _leverage, bool _isLong) external override {
        // 0. Transfer the settlement token from the user to the contract
        settlementToken.transferFrom(msg.sender, address(this), _size);

        // 1. Get the current position
        Position position = PositionLibrary.getPosition(msg.sender, _isLong);

        // 2.Get underlying price from the oracle
        uint256 ulPrice = getPrice(address(underlyingToken));

        // 3. Update the position & get the liquidation price
        position.open(ulPrice, _size, _leverage);
        uint256 liqPrice = position.getLiquidationPrice();

        // 4. Add the position to the list
        OpenPositionList.add(position);

        // 5. Emit an event
        emit PositionOpen(position, ulPrice, _size, _leverage, liqPrice, _isLong);
    }

    /**
     * @notice Close a position
     * @param _isLong The direction of the position
     */
    function closePosition(bool _isLong) external override {
        // 0. Get the current position
        Position position = PositionLibrary.getPosition(msg.sender, _isLong);

        // 1. Get the underlying price from the oracle
        uint256 ulPrice = getPrice(address(underlyingToken));

        // 2. Close the position
        uint256 closeSize = position.close(ulPrice);

        // 3. Transfer the settlement token to the user
        settlementToken.transfer(msg.sender, closeSize);

        // 4. Remove the position from the list
        OpenPositionList.remove(position);

        // 5. Emit an event
        emit PositionClose(position, ulPrice, closeSize, _isLong);
    }

    /**
     * @notice Liquidate a position
     * @param position The position to liquidate
     */
    function liquidatePosition(Position position) external override {
        // 0. Get the underlying price from the oracle
        uint256 ulPrice = getPrice(address(underlyingToken));

        // 1. Liquidate the position
        position.liquidate(ulPrice);

        // 2. Remove the position from the list
        OpenPositionList.remove(position);

        // 3. Emit an event
        emit PositionLiquidate(position, ulPrice);
    }

    /**
     * @notice Close all positions by force
     */
    function closeAllPositionForce() external {
        // 0. Get the all open positions
        Position[] memory positions = OpenPositionList.getPositionList();

        // 1. Close all positions
        uint closeSize;
        for (uint256 i = 0; i < positions.length; i++) {
            closeSize += positions[i].closeForce();
            OpenPositionList.remove(positions[i]);
        }

        // 2. Transfer the settlement token to the user
        settlementToken.transfer(msg.sender, closeSize);

        // 3. Emit an event
        emit PositionCloseForce(closeSize);
    }

    /**
     * @notice Get the position info
     * @param position The position to get the info
     */
    function getPositionInfo(Position position) external view override returns (PositionLibrary.PositionData memory) {
        return PositionLibrary.copy(position);
    }

    /**
     * @notice Get the open position list
     */
    function getOpenPositionList() external view returns (Position[] memory) {
        return OpenPositionList.getPositionList();
    }
}
