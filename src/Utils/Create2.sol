// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

library Create2 {
    function deploy(bytes memory bytecode, uint256 salt) internal returns (address) {
        address addr;
        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }
        return addr;
    }

    function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
        return computeAddress(salt, bytecodeHash, address(this));
    }

    function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encodePacked(hex"ff", deployer, salt, bytecodeHash)))));
    }
}
