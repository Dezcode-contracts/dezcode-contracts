// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

struct EnumerableSet {
    address[] _values;
    mapping(address => uint256) _indexes;
}

library EnumerableSetLib {
    function add(EnumerableSet storage set, address value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        }
        return false;
    }

    function remove(EnumerableSet storage set, address value) internal returns (bool) {
        uint256 valueIndex = set._indexes[value];
        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;
            if (lastIndex != toDeleteIndex) {
                address lastValue = set._values[lastIndex];
                set._values[toDeleteIndex] = lastValue;
                set._indexes[lastValue] = valueIndex;
            }
            set._values.pop();
            delete set._indexes[value];
            return true;
        }
        return false;
    }

    function contains(EnumerableSet storage set, address value) internal view returns (bool) {
        return set._indexes[value] != 0;
    }

    function length(EnumerableSet storage set) internal view returns (uint256) {
        return set._values.length;
    }

    function at(EnumerableSet storage set, uint256 index) internal view returns (address) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }
}
