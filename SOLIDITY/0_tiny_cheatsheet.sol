// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;


// - Structure of a contract.

// -- State Variables.
contract SimpleStorage {
    uint storedData; // State variable
    // ...
}


// -- Functions.
contract SimpleAuction {
    function bid() public payable { // Function
        // ...
    }
}

// Helper function defined outside of a contract
function helper(uint x) pure returns (uint) {
    return x * 2;
}


// -- Modifiers.
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


// -- Events.
contract SimpleAuction {
    event HighestBidIncreased(address bidder, uint amount); // Event (oracle)

    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // Triggering event
    }
}


// -- Errors.
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


// -- Struct Types.
contract Ballot {
    struct Voter { // Struct
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
}


// -- Enum Types.
// Enums cannot have more than 256 members.
// The data representation is the same as for enums in C: The options are represented by subsequent unsigned integer values starting from 0.
// Since enum types are not part of the ABI, the signature of the enum automatically be changed to "uint8" for all matters external to Solidity.
contract Purchase {
    enum State { Created, Locked, Inactive } // Enum
    
    // The state variable has a default value of the first member, `State.created`
    State public state;
}



// - Types.

// -- Operators.
/*
    ! (logical negation)
    && (logical conjunction, “and”)
    || (logical disjunction, “or”)
    == (equality)
    != (inequality)

    Comparisons: <=, <, ==, !=, >=, > (evaluate to bool)
    Bit operators: &, |, ^  (bitwise exclusive or), ~ (bitwise negation)
    Shift operators: << (left shift), >> (right shift)
    Arithmetic operators: +, -, unary - (only for signed integers), *, /, % (modulo), ** (exponentiation)
*/


// -- Value Types.

// --- Boolean.
bool b; // true or false.

// Integers.
int integer;           // Size can be specified, from int8  to int256. In steps of 8.
uint unsigner_integer; // Size can be specified, from uint8 to uint256. In steps of 8.

/*
! Integers in Solidity are restricted to a certain range. For example, with uint32, this is 0 up to 2**32 - 1. There are two modes in which arithmetic is performed on these types: The “wrapping” or “unchecked” mode and the “checked” mode. By default, arithmetic is always “checked”, which mean that if the result of an operation falls outside the value range of the type, the call is reverted through a failing assertion. You can switch to “unchecked” mode using unchecked { ... }.
Division by zero causes a Panic error. This check can not be disabled through unchecked { ... }.

! 'fixed' / 'ufixed': Signed and unsigned fixed point number of various sizes. Keywords 'ufixedMxN' and 'fixedMxN', where M represents the number of bits taken by the type and N represents how many decimal points are available. M must be divisible by 8 and goes from 8 to 256 bits. N must be between 0 and 80, inclusive. ufixed and fixed are aliases for ufixed128x18 and fixed128x18, respectively.
*/


// --- Address.
address variable; Holds a 20 byte value (size of an Ethereum address).
address payable variable; // Same as address, but with the additional members transfer and send.

/*
Implicit conversions from address payable to address are allowed, whereas conversions from address to address payable must be explicit via payable(<address>).
*/

// --- Fixed-size byte arrays.
bytes1 byte;         // The value types bytes1, bytes2, bytes3, …, bytes32 hold a sequence of bytes from one to up to 32.
bytes byte_array;    // Dynamically-sized byte array, see Arrays. Not a value-type!
string string_var;   // Dynamically-sized UTF-8-encoded string, see Arrays. Not a value-type!
string memory a = unicode"Hello 😃";

/*
    Comparisons: <=, <, ==, !=, >=, > (evaluate to bool)
    Bit operators: &, |, ^ (bitwise exclusive or), ~ (bitwise negation)
    Shift operators: << (left shift), >> (right shift)
    Index access: If x is of type bytesI, then x[k] for 0 <= k < I returns the k th byte (read-only).
    
    byte_array.length yields the fixed length of the byte array (read-only).

    The type byte[] is an array of bytes, but due to padding rules, it wastes 31 bytes of space for each element (except in storage). It is better to use the bytes type instead.
    
    Prior to version 0.8.0, byte used to be an alias for bytes1.
    
    While regular string literals can only contain ASCII, Unicode literals – prefixed with the keyword unicode – can contain any valid UTF-8 sequence. They also support the very same escape sequences as regular string literals.
    
*/



// - Notes.

/*
For an integer type X, you can use 'type(X).min' and 'type(X).max' to access the minimum and maximum value representable by the type.


The result of a shift operation has the type of the left operand, truncating the result to match the type. The right operand must be of unsigned type, trying to shift by an signed type will produce a compilation error.
Shifts can be “simulated” using multiplication by powers of two in the following way. Note that the truncation to the type of the left operand is always performed at the end, but not mentioned explicitly.
x << y is equivalent to the mathematical expression x * 2**y.
x >> y is equivalent to the mathematical expression x / 2**y, rounded towards negative infinity.


Overflow checks are never performed for shift operations as they are done for arithmetic operations. Instead, the result is always truncated.


The expression type(int).min / (-1) is the only case where division causes an overflow. In checked arithmetic mode, this will cause a failing assertion, while in wrapping mode, the value will be type(int).min.


There are some dangers in using send: The transfer fails if the call stack depth is at 1024 (this can always be forced by the caller) and it also fails if the recipient runs out of gas. So in order to make safe Ether transfers, always check the return value of send, use transfer or even better: use a pattern where the recipient withdraws the money.


All three functions call, delegatecall and staticcall are very low-level functions and should only be used as a last resort as they break the type-safety of Solidity.
The gas option is available on all three methods, while the value option is only available on call.


It is best to avoid relying on hardcoded gas values in your smart contract code, regardless of whether state is read from or written to, as this can have many pitfalls. Also, access to gas might change in the future.


All contracts can be converted to address type, so it is possible to query the balance of the current contract using 'address(this).balance'.


Scientific notation is also supported, where the base can have fractions and the exponent cannot. Examples include 2e10, -2e10, 2e-10, 2.5e1.


Division on integer literals used to truncate in Solidity prior to version 0.4.0, but it now converts into a rational number, i.e. 5 / 2 is not equal to 2, but to 2.5.


Strings, as with integer literals, their type can vary, but they are implicitly convertible to bytes1, …, bytes32, if they fit, to bytes and to string.
For example, with bytes32 samevar = "stringliteral" the string literal is interpreted in its raw byte form when assigned to a bytes32 type.
    String literals can only contain printable ASCII characters, which means the characters between and including 0x1F .. 0x7E.
    Additionally, string literals also support the following escape characters:

    \<newline> (escapes an actual newline)
    \\ (backslash)
    \' (single quote)
    \" (double quote)
    \b (backspace)
    \f (form feed)
    \n (newline)
    \r (carriage return)
    \t (tab)
    \v (vertical tab)
    \xNN (hex escape, see below)
    \uNNNN (unicode escape, see below)
    \xNN takes a hex value and inserts the appropriate byte, while \uNNNN takes a Unicode codepoint and inserts an UTF-8 sequence.


Without the 'memory' keyword, Solidity tries to declare variables in storage. The memory keyword tells solidity to create a chunk of space for the variable at method runtime, guaranteeing its size and structure for future use in that method. memory cannot be used at the contract level. Only in methods.
You can think of storage as a large array that has a virtual structure a structure you cannot change at runtime - it is determined by the state variables in your contract.


Since enum types are not part of the ABI, the signature of the enum automatically be changed to "uint8" for all matters external to Solidity.



*/