// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AccessControl} from "../Access/AccessControl.sol";

contract AccessControlMock is AccessControl {
    function onlyRoleMock(bytes32 role) public view onlyRole(role) {
        // Function for testing onlyRole modifier
    }

    function getRoleAdminMock(bytes32 role) public view returns (bytes32) {
        return getRoleAdmin(role);
    }
}
