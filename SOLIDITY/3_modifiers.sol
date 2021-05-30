// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/*
@title counter
@notice a simple smart contract that counts the "increment" function calls.
@author MrFrenzoid
*/
contract Counter {
    
    // Events
    /* 
    @param oldValue is the old value of the Counter
    @param newValue is the new value of the Counter
    */
    event ValueChanged(uint256 oldValue, uint256 newValue);
    
    
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Stop right there, criminal scum! Nobody breaks the law on my watch! I'm confiscating your stolen goods. Now pay your fine or it's off to jail.");
        // _; is replaced with the body of the function that used this modifier,
        //       this is used to continue with the normal exection of the function of the "require" goes fine.
        _;
    }
    
    
    
    // Variables ( storage )
    uint256 private count = 0;
    address private owner;

    
    
    // Constructor
    constructor() {
        // The constructor is only called when the contract is deployed,
        //   so the msg.sender will be the user deploying the contract.
        
        owner = msg.sender;
    }
    
    
    
    // Getters & Setters
    /*
    @notice Gets the counter value.
    */
    function getCount() public view returns (uint256) {
        return count;
    }
    
    /*
    @notice Sets the counter value.
    @param newValue is the new value to be setted.
    */
    function setCount(uint256 newValue) public onlyOwner {
        uint256 oldValue = count;
        count = newValue;
        
        emit ValueChanged(oldValue, newValue);
    }
    
    
    
    // Functions
    
    /*
    @notice increments the counter by 1.
    */
    function increment() public {
        setCount(count++);
    }
    
    /*
    @notice decrements the counter by 1.
    */
    function decrement() public {
        setCount(count--);
    }
}
