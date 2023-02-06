// SPDX-License-Identifier: GNU General Public License v2.0 or later
pragma solidity ^0.8.0;

contract Content {
    address owner;
    mapping(address => uint256) contentConsumers;
    uint256 contentPurchasePrice;
    uint256 contentRentPrice;
    uint256 balance;

    constructor(address _owner) {
        owner = _owner;
    }

    function deposit() public payable {
        require(msg.sender == owner || contentConsumers[msg.sender] > 0, "Only owner and active content consumers can deposit.");
        balance += msg.value;
    }

    function withdraw(uint256 _amount) public payable {
        require(msg.sender == owner, "Only owner can withdraw.");
        require(balance >= _amount, "Insufficient balance.");
        address payable to = payable(msg.sender);
        to.transfer(_amount);
        balance -= _amount;
    }

    function signTransaction(address payable _to, uint256 _value) public {
        require(msg.sender == owner || (contentConsumers[msg.sender] > 0 && contentConsumers[msg.sender] > block.timestamp), "Only owner and active content consumers can sign transactions.");
        _to.transfer(_value);
    }

    function addContentConsumer(address _contentConsumer, uint256 _duration) public {
        require(msg.sender == owner, "Only owner can add content consumers.");
        contentConsumers[_contentConsumer] = block.timestamp + _duration;
    }

    function removeContentConsumer(address _contentConsumer) public {
        require(msg.sender == owner, "Only owner can remove content consumers.");
        delete contentConsumers[_contentConsumer];
    }

    function setContentPurchasePrice(uint256 _price) public {
        require(msg.sender == owner, "Only owner can set the secondary owner price.");
        contentPurchasePrice = _price;
    }

    function buyContent() public payable {
        require(msg.value >= contentPurchasePrice, "Insufficient amount.");
        addContentConsumer(msg.sender, type(uint128).max);
    }

    function setContentRentPrice(uint256 _price) public {
        require(msg.sender == owner, "Only owner can set the secondary owner rental price.");
        contentRentPrice = _price;
    }

    function rentContent(uint256 _duration) public payable {
        require(msg.value >= contentRentPrice * _duration, "Insufficient amount.");
        addContentConsumer(msg.sender, _duration);
    }
}

contract W3FlixFactory {
    function createContent(address _owner) public returns (address) {
        Content newContent = new Content(_owner);
        return address(newContent);
    }
}
