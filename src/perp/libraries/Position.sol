// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

type Position is bytes32;

using { equal as == } for Position global;

function equal(Position a, Position b) pure returns (bool) {
    return Position.unwrap(a) == Position.unwrap(b);
}