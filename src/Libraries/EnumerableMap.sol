// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

struct EnumerableMap {
    address[] _keys;
    mapping(address => uint256) _values;
    mapping(address => uint256) _indexes;
}

library EnumerableMapLib {
    function set(EnumerableMap storage map, address key, uint256 value) internal returns (bool) {
        uint256 index = map._indexes[key];
        if (index == 0) {
            map._keys.push(key);
            map._values[key] = value;
            map._indexes[key] = map._keys.length;
            return true;
        } else {
            map._values[key] = value;
            return false;
        }
    }

    function remove(EnumerableMap storage map, address key) internal returns (bool) {
        uint256 index = map._indexes[key];
        if (index != 0) {
            uint256 toDeleteIndex = index - 1;
            uint256 lastIndex = map._keys.length - 1;
            if (lastIndex != toDeleteIndex) {
                address lastKey = map._keys[lastIndex];
                map._keys[toDeleteIndex] = lastKey;
                map._indexes[lastKey] = index;
            }
            map._keys.pop();
            delete map._values[key];
            delete map._indexes[key];
            return true;
        }
        return false;
    }

    function contains(EnumerableMap storage map, address key) internal view returns (bool) {
        return map._indexes[key] != 0;
    }

    function length(EnumerableMap storage map) internal view returns (uint256) {
        return map._keys.length;
    }

    function at(EnumerableMap storage map, uint256 index) internal view returns (address, uint256) {
        require(map._keys.length > index, "EnumerableMap: index out of bounds");
        return (map._keys[index], map._values[map._keys[index]]);
    }

    function get(EnumerableMap storage map, address key) internal view returns (uint256) {
        return map._values[key];
    }
}
