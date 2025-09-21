// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

abstract contract EIP712 {
    bytes32 private immutable _DOMAIN_SEPARATOR;
    string private constant _EIP712_VERSION = "1";

    constructor(string memory name) {
        _DOMAIN_SEPARATOR = _buildDomainSeparator(name);
    }

    function _domainSeparatorV4() internal view returns (bytes32) {
        return _DOMAIN_SEPARATOR;
    }

    function _buildDomainSeparator(string memory name) private view returns (bytes32) {
        return keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name)),
                keccak256(bytes(_EIP712_VERSION)),
                block.chainid,
                address(this)
            )
        );
    }

    function _hashTypedDataV4(bytes32 structHash) internal view returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
    }
}
