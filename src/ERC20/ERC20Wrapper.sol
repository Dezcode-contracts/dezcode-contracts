// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "../Interfaces/IERC20.sol";
import {IERC20Metadata} from "../Interfaces/IERC20Metadata.sol";
import {Context} from "../Utils/Context.sol";

abstract contract ERC20Wrapper is Context, IERC20, IERC20Metadata {
    IERC20 internal immutable _underlying;

    constructor(IERC20 underlyingToken) {
        require(underlyingToken != IERC20(address(0)), "ERC20Wrapper: underlying token is zero address");
        _underlying = underlyingToken;
    }

    function underlying() public view virtual returns (IERC20) {
        return _underlying;
    }

    function depositFor(address account, uint256 amount) public virtual returns (bool) {
        require(account != address(0), "ERC20Wrapper: deposit to zero");
        _underlying.transferFrom(_msgSender(), address(this), amount);
        _mint(account, amount);
        return true;
    }

    function withdrawTo(address account, uint256 amount) public virtual returns (bool) {
        require(account != address(0), "ERC20Wrapper: withdraw to zero");
        _burn(_msgSender(), amount);
        _underlying.transfer(account, amount);
        return true;
    }

    function decimals() public view virtual override returns (uint8) {
        try IERC20Metadata(address(_underlying)).decimals() returns (uint8 value) {
            return value;
        } catch {
            return super.decimals();
        }
    }
}
