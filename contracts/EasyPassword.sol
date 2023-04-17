// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./PasswordManager.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract EasyPassword is Pausable, Ownable {
    using Strings for uint256;
    PasswordGroup private _groupManager;
    PasswordManager private _passworkManager;

    constructor() {
        _groupManager = new PasswordGroup();
        _passworkManager = new PasswordManager();
    }

    function insertOrUpdate(string memory group_, string memory key_, string memory password_) public {
        _requireNotPaused();
        if (_passworkManager._existsKey(key_)) {
            _passworkManager.updateByKey(key_, password_);
        } else {
            _passworkManager.addPassword(group_, key_, password_);
        }
    }

    function createGroup(string memory name_) public {
        _requireNotPaused();
        _groupManager.createGroup(name_);
    }

    function loadGroups() public view returns(string[] memory) {
        return _groupManager.loadGroups();
    }

    function loadPasswords() public view returns(PasswordInfo[] memory) {
        return _passworkManager.loadPasswords();
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}