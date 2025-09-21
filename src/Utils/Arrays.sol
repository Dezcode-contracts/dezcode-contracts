// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

library Arrays {
    function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
        if (array.length == 0) return 0;
        uint256 low = 0;
        uint256 high = array.length;
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (array[mid] > element) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return low;
    }
}
