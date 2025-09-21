// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

abstract contract Multicall {
    function multicall(bytes[] calldata data) external payable returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            results[i] = success ? result : _getRevertMsg(result);
        }
    }

    function _getRevertMsg(bytes memory revertData) internal pure returns (bytes memory) {
        if (revertData.length >= 4) {
            return revertData;
        }
        return "Multicall: revert";
    }
}
