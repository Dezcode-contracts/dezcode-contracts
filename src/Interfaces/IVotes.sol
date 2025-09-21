// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface IVotes {
    struct Checkpoint {
        uint32 fromBlock;
        uint224 votes;
    }

    function checkpoints(address account, uint32 pos) external view returns (Checkpoint memory);
    function numCheckpoints(address account) external view returns (uint32);
    function delegates(address account) external view returns (address);
    function getVotes(address account) external view returns (uint256);
    function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
    function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
    event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
}
