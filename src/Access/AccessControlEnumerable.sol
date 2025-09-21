// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AccessControl} from "./AccessControl.sol";
import {EnumerableSet} from "../Libraries/EnumerableSet.sol";

abstract contract AccessControlEnumerable is AccessControl {
    using EnumerableSet for EnumerableSet.AddressSet;
    mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;

    function getRoleMember(bytes32 role, uint256 index) public view virtual returns (address) {
        return _roleMembers[role].at(index);
    }

    function getRoleMemberCount(bytes32 role) public view virtual returns (uint256) {
        return _roleMembers[role].length();
    }

    function _grantRole(bytes32 role, address account) internal virtual override {
        super._grantRole(role, account);
        _roleMembers[role].add(account);
    }

    function _revokeRole(bytes32 role, address account) internal virtual override {
        super._revokeRole(role, account);
        _roleMembers[role].remove(account);
    }
}
