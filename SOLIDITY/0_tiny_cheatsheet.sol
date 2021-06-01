// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

// - State Variables.
contract SimpleStorage {
    uint storedData; // State variable
    // ...
}


// - Functions.
contract SimpleAuction {
    function bid() public payable { // Function
        // ...
    }
}

// Helper function defined outside of a contract
function helper(uint x) pure returns (uint) {
    return x * 2;
}


// - Modifiers.
contract Purchase {
    address public seller;

    modifier onlySeller() { // Modifier
        require(
            msg.sender == seller,
            "Only seller can call this."
        );
        
        _;
    }

    function abort() public view onlySeller { // Modifier usage
        // ...
    }
}


// - Events.
contract SimpleAuction {
    event HighestBidIncreased(address bidder, uint amount); // Event (oracle)

    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // Triggering event
    }
}


// - Errors.
/// Not enough funds for transfer. Requested `requested`,
/// but only `available` available.
error NotEnoughFunds(uint requested, uint available);

contract Token {
    mapping(address => uint) balances;
    
    function transfer(address to, uint amount) public {
        uint balance = balances[msg.sender];
        
        if (balance < amount)
            revert NotEnoughFunds(amount, balance);
            
        balances[msg.sender] -= amount;
        balances[to] += amount;
        // ...
    }
}


// - Struct Types.
contract Ballot {
    struct Voter { // Struct
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
}


// - Enum Types.
contract Purchase {
    enum State { Created, Locked, Inactive } // Enum
    
    // The state variable has a default value of the first member, `State.created`
    State public state;
}
