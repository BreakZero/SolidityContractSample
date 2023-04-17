// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

struct PasswordInfo {
    string group;
    string key;
    string password;
    uint timestamp;
}

contract PasswordManager {
    

    mapping(address => PasswordInfo[]) _passwords;

    function addPassword(string memory group_, string memory key_, string memory password_) public {
        PasswordInfo memory info_ = PasswordInfo(group_, key_, password_, block.timestamp);
        _passwords[msg.sender].push(info_);
    }

    function updateByKey(string memory key_, string memory password_) public view {
        PasswordInfo[] memory passwords_ = _passwords[msg.sender];
        for (uint i = 0; i < _passwords[msg.sender].length; i++) {
            PasswordInfo memory info_ = passwords_[i];
            if (compareStrings(key_, info_.key)) {
                info_.password = password_;
            }
        }
    }

    function loadPasswords() public view returns(PasswordInfo[] memory) {
        PasswordInfo[] memory infos = _passwords[msg.sender];
        return infos;
    } 

    function _existsKey(string memory key_) public view virtual returns (bool) {
        PasswordInfo[] memory passwords_ = _passwords[msg.sender];
        if (passwords_.length == 0) return false;
        for (uint i = 0; i < _passwords[msg.sender].length; i++) {
            PasswordInfo memory info_ = passwords_[i];
            if (compareStrings(key_, info_.key)) {
                return true;
            }
        }
        return false;
    }

    function compareStrings(string memory first, string memory second) private pure returns (bool) {
        return (keccak256(abi.encodePacked((first))) == keccak256(abi.encodePacked((second))));
    }
}

contract PasswordGroup {
    // mapping for address to groups
    mapping(address => string[]) private _groups;

    function createGroup(string memory name_) public {
        require(!_existsGroup(name_), "Sorry, group has existsed");
        _groups[msg.sender].push(name_);
    }

    function loadGroups() public view returns(string[] memory) {
        return _groups[msg.sender];
    }

    function _existsGroup(string memory name_) internal view virtual returns (bool) {
        string[] memory groups_ = _groups[msg.sender];
        if (groups_.length == 0) return false;
        for (uint i = 0; i < _groups[msg.sender].length; i++) {
            string memory group_ = groups_[i];
            if (compareStrings(name_, group_)) {
                return true;
            }
        }
        return false;
    }

    function compareStrings(string memory first, string memory second) private pure returns (bool) {
        return (keccak256(abi.encodePacked((first))) == keccak256(abi.encodePacked((second))));
    }
}