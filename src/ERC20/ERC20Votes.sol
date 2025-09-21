// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20Permit} from "./ERC20Permit.sol";
import {IVotes} from "../Interfaces/IVotes.sol";
import {Checkpoints} from "../Utils/Checkpoints.sol";

abstract contract ERC20Votes is ERC20Permit, IVotes {
    using Checkpoints for Checkpoints.Trace208;
    Checkpoints.Trace208 private _totalCheckpoints;
    mapping(address => Checkpoints.Trace208) private _delegateCheckpoints;
    mapping(address => address) private _delegates;

    constructor(string memory name) ERC20Permit(name) {}

    function checkpoints(address account, uint32 pos) public view virtual override returns (IVotes.Checkpoint memory) {
        return _delegateCheckpoints[account].getAt(pos);
    }

    function numCheckpoints(address account) public view virtual override returns (uint32) {
        return _delegateCheckpoints[account].length();
    }

    function delegates(address account) public view virtual override returns (address) {
        return _delegates[account];
    }

    function getVotes(address account) public view virtual override returns (uint256) {
        return _delegateCheckpoints[account].latest();
    }

    function getPastVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
        require(blockNumber < block.number, "ERC20Votes: block not yet mined");
        return _delegateCheckpoints[account].getAtBlock(blockNumber);
    }

    function getPastTotalSupply(uint256 blockNumber) public view virtual override returns (uint256) {
        require(blockNumber < block.number, "ERC20Votes: block not yet mined");
        return _totalCheckpoints.getAtBlock(blockNumber);
    }

    function _delegate(address delegator, address delegatee) internal virtual {
        address currentDelegate = delegates(delegator);
        uint256 delegatorBalance = balanceOf(delegator);
        _delegates[delegator] = delegatee;
        emit DelegateChanged(delegator, currentDelegate, delegatee);
        _moveVotingPower(delegator, currentDelegate, delegatee, delegatorBalance);
    }

    function _moveVotingPower(address src, address dst, uint256 amount) private {
        if (src != dst && amount > 0) {
            if (src != address(0)) {
                uint256 srcVotes = getVotes(src);
                uint256 newSrcVotes = srcVotes - amount;
                _writeCheckpoint(src, newSrcVotes);
                emit VotesChanged(src, srcVotes, newSrcVotes);
            }
            if (dst != address(0)) {
                uint256 dstVotes = getVotes(dst);
                uint256 newDstVotes = dstVotes + amount;
                _writeCheckpoint(dst, newDstVotes);
                emit VotesChanged(dst, dstVotes, newDstVotes);
            }
        }
    }

    function _writeCheckpoint(address account, uint256 newVotes) private {
        uint256 pos = _delegateCheckpoints[account].push(newVotes);
        emit DelegateVotesChanged(account, pos, newVotes);
    }

    function _mint(address to, uint256 amount) internal virtual override {
        super._mint(to, amount);
        _writeCheckpoint(to, getVotes(to) + amount);
    }

    function _burn(address from, uint256 amount) internal virtual override {
        super._burn(from, amount);
        _writeCheckpoint(from, getVotes(from) - amount);
    }

    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        _moveVotingPower(from, to, amount);
    }
}
