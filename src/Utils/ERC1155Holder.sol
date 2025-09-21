// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC1155Receiver} from "../Interfaces/IERC1155Receiver.sol";

contract ERC1155Holder is IERC1155Receiver {
    function onERC1155Received(address, address, uint256, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}
