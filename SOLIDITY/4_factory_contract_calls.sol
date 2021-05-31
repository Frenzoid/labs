// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/*
@title counter
@author MrFrenzoid
*/
contract Counter {
    
    uint256 private count;
    address private owner;
    address private factory;

    
    modifier onlyOwner(address caller) {
        require(caller == owner, "You're not the owner of the contract");
        _;
    }
    
    modifier onlyFactory() {
        require(msg.sender == factory, "You need to use the factory");
        _;
    }
    
    constructor(address _owner) {
        owner = _owner;
        factory = msg.sender;
    }
    
     function getCount() public view returns (uint256) {
        return count;
    }
    
    function increment(address caller) public onlyFactory onlyOwner(caller) {
        count++;
    }

}



/*
@title CounterFactory
@author MrFrenzoid
*/
contract CounterFactory {
    mapping(address => Counter) counters;
    
    
    function createCounter() public {
        require (counters[msg.sender]== Counter(address(0x0)), "User already has a counter");
        counters[msg.sender] = new Counter(msg.sender);
    }
    
    function increment() public {
        require (counters[msg.sender] != Counter(address(0x0)), "User doesnt own a counter");
        counters[msg.sender].increment(msg.sender);
    }
    
    function getCount(address account) public view returns (uint256) {
        require (counters[account] != Counter(address(0x0)), "User doesnt own a counter");
        return counters[account].getCount();
    }
    
    function getMyCount() public view returns (uint256) {
        return getCount(msg.sender);
    }
}
