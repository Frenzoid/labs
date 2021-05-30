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
    event ValueChanged(uint oldValue, uint256 newValue);
    
    // Variables ( storage )
    uint256 private count = 0;
    
    // Getters
    function getCount() public view returns (uint256) {
        return count;
    }
    
    // Functions
    function increment() public {
        count += 1;
        emit ValueChanged(count - 1, count);
    }
    
}
