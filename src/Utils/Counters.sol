// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

struct Counters {
    uint256 _value;
}

library CountersLib {
    function current(Counters storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counters storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counters storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counters: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counters storage counter) internal {
        counter._value = 0;
    }
}
