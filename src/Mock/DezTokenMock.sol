// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {DezToken} from "../Token/DezToken.sol";

contract DezTokenMock is DezToken {
    constructor(string memory name, string memory symbol) DezToken(name, symbol) {}
}
