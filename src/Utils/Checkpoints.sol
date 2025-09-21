// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

struct Checkpoint {
    uint32 fromBlock;
    uint224 votes;
}

struct Trace208 {
    Checkpoint[] _checkpoints;
}

library CheckpointsLib {
    function push(Trace208 storage self, uint224 newValue) internal returns (uint32) {
        uint32 pos = uint32(self._checkpoints.length);
        if (pos > 0 && self._checkpoints[pos - 1].fromBlock == block.number) {
            self._checkpoints[pos - 1].votes = newValue;
        } else {
            self._checkpoints.push(Checkpoint({fromBlock: uint32(block.number), votes: newValue}));
        }
        return pos;
    }

    function getAt(Trace208 storage self, uint32 pos) internal view returns (Checkpoint memory) {
        return self._checkpoints[pos];
    }

    function latest(Trace208 storage self) internal view returns (uint224) {
        uint256 pos = self._checkpoints.length;
        return pos == 0 ? 0 : self._checkpoints[pos - 1].votes;
    }

    function length(Trace208 storage self) internal view returns (uint32) {
        return uint32(self._checkpoints.length);
    }

    function getAtBlock(Trace208 storage self, uint256 blockNumber) internal view returns (uint224) {
        uint256 high = self._checkpoints.length;
        if (high == 0) return 0;
        uint256 low = 0;
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (self._checkpoints[mid].fromBlock > blockNumber) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return high == 0 ? 0 : self._checkpoints[high - 1].votes;
    }
}
