// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStorage {
    uint public oneNumber = 0;

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public personList;
    mapping(string => uint256) public nameToNumberMap;

    // int  otherNumber = 0;
    // address myAddress = 0x52982B1AF34a7823f17e407Db831687298741593;
    function store(uint256 _oneNumber) public virtual {
        oneNumber = _oneNumber;
    }

    function look() public view returns (uint256) {
        return oneNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        personList.push(Person({favoriteNumber: _favoriteNumber, name: _name}));
        nameToNumberMap[_name] = _favoriteNumber;
    }
}
