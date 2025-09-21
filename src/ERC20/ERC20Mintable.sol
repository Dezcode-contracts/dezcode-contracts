// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "./ERC20.sol";
import {Ownable} from "../Access/Ownable.sol";

abstract contract ERC20Mintable is ERC20, Ownable {
    function mint(address to, uint256 amount) public virtual onlyOwner {
        _mint(to, amount);
    }
}
