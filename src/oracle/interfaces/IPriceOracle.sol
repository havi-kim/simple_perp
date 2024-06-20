// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IPriceOracle {
    /// @dev Store the oracle object to storage.
    function setPrice(address _token, uint256 _price) external;

    /// @dev Get the price from storage.
    function getPrice(address _token) external view returns (uint256 price);
}
