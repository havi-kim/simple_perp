// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IPerpetual} from "src/perp/interfaces/IPerpetual.sol";
import {IPriceOracle} from "src/oracle/interfaces/IPriceOracle.sol";
import {IERC20} from "src/utils/interfaces/IERC20.sol";

contract MockAccount {
    IPerpetual private perpetual;

    constructor(address _perpetual, address _settlementToken){
        perpetual = IPerpetual(_perpetual);
        IERC20(_settlementToken).approve(_perpetual, type(uint256).max);
    }

    function openPosition(uint256 _size, uint256 _leverage, bool _isLong) external {
        perpetual.openPosition(_size, _leverage, _isLong);
    }

    function closePosition(bool _isLong) external {
        perpetual.closePosition(_isLong);
    }
}
