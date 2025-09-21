// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "./ERC20.sol";
import {IERC3156FlashBorrower} from "../Interfaces/IERC3156FlashBorrower.sol";
import {IERC3156FlashLender} from "../Interfaces/IERC3156FlashLender.sol";

abstract contract ERC20FlashMint is ERC20, IERC3156FlashLender {
    bytes32 private constant _RETURN_VALUE = keccak256("ERC3156FlashBorrower.onFlashLoan");

    function maxFlashLoan(address token) public view virtual override returns (uint256) {
        return token == address(this) ? type(uint256).max - totalSupply() : 0;
    }

    function flashFee(address token, uint256 amount) public view virtual override returns (uint256) {
        require(token == address(this), "ERC20FlashMint: wrong token");
        return 0;
    }

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) public virtual override returns (bool) {
        require(token == address(this), "ERC20FlashMint: wrong token");
        require(amount <= maxFlashLoan(token), "ERC20FlashMint: amount exceeds max");
        uint256 fee = flashFee(token, amount);
        _mint(address(receiver), amount);
        require(
            receiver.onFlashLoan(_msgSender(), token, amount, fee, data) == _RETURN_VALUE,
            "ERC20FlashMint: invalid return value"
        );
        uint256 currentBalance = balanceOf(address(receiver));
        require(currentBalance >= amount, "ERC20FlashMint: insufficient balance");
        _burn(address(receiver), currentBalance);
        return true;
    }
}
