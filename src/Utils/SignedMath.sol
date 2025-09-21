// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

library SignedMath {
    int256 constant private _INT256_MIN = -2**255;

    function max(int256 a, int256 b) internal pure returns (int256) {
        return a >= b ? a : b;
    }

    function min(int256 a, int256 b) internal pure returns (int256) {
        return a <= b ? a : b;
    }

    function average(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        return c - a == b ? c >> 1 : (c >> 1) + (c & 1);
    }

    function abs(int256 value) internal pure returns (int256) {
        require(value != _INT256_MIN, "SignedMath: abs overflow");
        return value < 0 ? -value : value;
    }
}
