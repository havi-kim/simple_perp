//SPDX-License-Identifier: MIT
pragma solidity >=0.8.24 <0.9.0;

import "./interfaces/IPriceOracle.sol";

/**
 * @title SimplePriceOracle
 * @dev The SimplePriceOracle contract is used to store the price of the token.
 *      This is for testing purposes only. So no need to check access control.
 */
contract SimplePriceOracle is IPriceOracle {
    bytes32 private constant _PRICE_ORACLE_STORAGE = keccak256(abi.encode("simple_perp.src.oracle.PriceOracle"));

    event PriceSet(address indexed token, uint256 price);

    /// @dev Store the oracle object to storage.
    function setPrice(address _token, uint256 _price) external override {
        bytes32 location = getKey(_token);
        assembly {
            sstore(location, _price)
        }

        // Emit an event.
        emit PriceSet(_token, _price);
    }

    /// @dev Get the price from storage.
    function getPrice(address _token) public view override returns (uint256 price) {
        bytes32 location = getKey(_token);
        assembly {
            price := sload(location)
        }
    }

    /// @dev Returns the key of storage.
    function getKey(address _token) private pure returns (bytes32 location) {
        location = _PRICE_ORACLE_STORAGE;
        assembly ("memory-safe") {
            mstore(0x0, location)
            mstore(0x20, _token)
            location := keccak256(0x0, 0x40)
        }
    }
}
