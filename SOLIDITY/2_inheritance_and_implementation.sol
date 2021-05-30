// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/*
    @title counter
    @notice a simple smart contract that counts the "increment" function calls.
    @author MrFrenzoid
*/
abstract contract Counter {
    
    // Events
    /* 
    @param oldValue is the old value of the Counter
    @param newValue is the new value of the Counter
    */
    event ValueChanged(uint256 oldValue, uint256 newValue);
    
    
    // Variables ( storage )
    uint256 private count = 0;
    
    
    // Constructor
    constructor(uint256 startValue) {
        count = startValue;
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
    function setCounter(uint256 newValue) internal {
        uint256 oldValue = count;
        count = newValue;
        
        emit ValueChanged(oldValue, newValue);

    }
    
    
    /*
    @notice abstract child function to be implemented on inheritance.
    */
    function step() virtual public;
}


/*
    @title counter inheritance
    @notice A contract that inherits the Counter contract and implements the step function, it increments.
    @author MrFrenzoid
*/
contract IncrementCounter is Counter {
    constructor(uint256 startValue) Counter(startValue){}
    
    function step() public override {
        setCounter(getCount() + 1);
    }
}


/*
    @title counter inheritance
    @notice A contract that inherits the Counter contract and implements the step function, it decrements.
    @author MrFrenzoid
*/
contract DecrementCounter is Counter {
    
    constructor(uint256 startValue) Counter(startValue){}
    
    function step() public override {
        setCounter(getCount() - 1);
    }
}
