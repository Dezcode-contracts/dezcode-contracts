// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "../ERC20/ERC20.sol";
import {ERC20Burnable} from "../ERC20/ERC20Burnable.sol";
import {ERC20Pausable} from "../ERC20/ERC20Pausable.sol";
import {ERC20Permit} from "../ERC20/ERC20Permit.sol";
import {AccessControl} from "../Access/AccessControl.sol";

contract DezToken is ERC20, ERC20Burnable, ERC20Pausable, ERC20Permit, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    constructor(string memory name, string memory symbol) ERC20(name, symbol) ERC20Permit(name) {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());
        _grantRole(PAUSER_ROLE, _msgSender());
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
