// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "./ERC20.sol";
import {Arrays} from "../Utils/Arrays.sol";
import {Counters} from "../Utils/Counters.sol";

contract ERC20Snapshot is ERC20 {
    using Arrays for uint256[];
    using Counters for Counters.Counter;

    struct Snapshots {
        uint256[] ids;
        uint256[] values;
    }

    mapping(address => Snapshots) private _accountBalanceSnapshots;
    Snapshots private _totalSupplySnapshots;
    Counters.Counter private _currentSnapshotId;

    event Snapshot(uint256 id);

    function snapshot() public virtual {
        _currentSnapshotId.increment();
        emit Snapshot(_currentSnapshotId.current());
    }

    function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
        return _valueAt(snapshotId, _accountBalanceSnapshots[account]);
    }

    function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
        return _valueAt(snapshotId, _totalSupplySnapshots);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        if (from == address(0)) {
            _updateAccountSnapshot(to);
            _updateTotalSupplySnapshot();
        } else if (to == address(0)) {
            _updateAccountSnapshot(from);
            _updateTotalSupplySnapshot();
        } else {
            _updateAccountSnapshot(from);
            _updateAccountSnapshot(to);
        }
    }

    function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (uint256) {
        require(snapshotId > 0, "ERC20Snapshot: id is 0");
        require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
        uint256 index = snapshots.ids.findUpperBound(snapshotId);
        return index == snapshots.ids.length ? 0 : snapshots.values[index];
    }

    function _updateAccountSnapshot(address account) private {
        _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
    }

    function _updateTotalSupplySnapshot() private {
        _updateSnapshot(_totalSupplySnapshots, totalSupply());
    }

    function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
        uint256 currentId = _currentSnapshotId.current();
        if (snapshots.ids.length == 0 || snapshots.ids[snapshots.ids.length - 1] < currentId) {
            snapshots.ids.push(currentId);
            snapshots.values.push(currentValue);
        }
    }
}
