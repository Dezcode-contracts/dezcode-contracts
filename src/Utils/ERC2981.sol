// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC165} from "./ERC165.sol";
import {IERC2981} from "../Interfaces/IERC2981.sol";

abstract contract ERC2981 is ERC165, IERC2981 {
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}
