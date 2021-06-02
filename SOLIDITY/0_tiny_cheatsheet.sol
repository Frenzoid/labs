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
// Defines a new type with two fields.
// Declaring a struct outside of a contract allows
// it to be shared by multiple contracts.
// Here, this is not really needed.
struct Funder {
    address addr;
    uint amount;
}

contract CrowdFunding {
    // Structs can also be defined inside contracts, which makes them
    // visible only there and in derived contracts.
    struct Campaign {
        address payable beneficiary;
        uint fundingGoal;
        uint numFunders;
        uint amount;
        mapping (uint => Funder) funders;
    }

    uint numCampaigns;
    mapping (uint => Campaign) campaigns;

    function newCampaign(address payable beneficiary, uint goal) public returns (uint campaignID) {
        campaignID = numCampaigns++; // campaignID is return variable
        // We cannot use "campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0)"
        // because the RHS creates a memory-struct "Campaign" that contains a mapping.
        // "Right Hand Side" As in referring to the right part of the statement campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0) i.e They are saying that Campaign(beneficiary, goal, 0, 0) is creating a struct in-memory.
        
        Campaign storage c = campaigns[campaignID];
        c.beneficiary = beneficiary;
        c.fundingGoal = goal;
    }

    function contribute(uint campaignID) public payable {
        Campaign storage c = campaigns[campaignID];
        // Creates a new temporary memory struct, initialised with the given values
        // and copies it over to storage.
        // Note that you can also use Funder(msg.sender, msg.value) to initialise.
        c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }

    function checkGoalReached(uint campaignID) public returns (bool reached) {
        Campaign storage c = campaigns[campaignID];
        if (c.amount < c.fundingGoal)
            return false;
        uint amount = c.amount;
        c.amount = 0;
        c.beneficiary.transfer(amount);
        return true;
    }
    // Note how in the functions, a struct type is assigned to a local variable with data location storage. This does not copy the struct but only stores a reference so that assignments to members of the local variable actually write to the state.
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
bytes1 byte_var = "a";         // The value types bytes1, bytes2, bytes3, …, bytes32 hold a sequence of bytes from one to up to 32.
bytes byte_array = "abcdfg";   // Dynamically-sized byte array, see Arrays. Not a value-type!
string string_var = "Hello";   // Dynamically-sized UTF-8-encoded string, see Arrays. Not a value-type!

// Remember, bytes types are processed as an array of bytes, implicit string literals are parsed to bytes, and they will be processed as such!

// While regular string literals can only contain ASCII, Unicode literals – prefixed with the keyword unicode – can contain any valid UTF-8 sequence. They also support the very same escape sequences as regular string literals.
string a = unicode"Hello 😃";

if (keccak256(bytes(string_var)) == keccak256(bytes("Hello"))
 && keccak256(bytes(byte_array)) == keccak256(bytes("abcdfg"))) { // true
    // ...
}

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


Accessing an array past its end causes a failing assertion. Methods .push() and .push(value) can be used to append a new element at the end of the array, where .push() appends a zero-initialized element and returns a reference to it.


Data locations are not only relevant for persistency of data, but also for the semantics of assignments:

Assignments between storage and memory (or from calldata) always create an independent copy.
Assignments from memory to memory only create references. This means that changes to one memory variable are also visible in all other memory variables that refer to the same data.
Assignments from storage to a local storage variable also only assign a reference.
All other assignments to storage always copy. Examples for this case are assignments to state variables or to members of local variables of storage struct type, even if the local variable itself is just a reference.


Variables of type bytes and string are special arrays. A bytes is similar to byte[], but it is packed tightly in calldata and memory. string is equal to bytes but does not allow length or index access.


Solidity does not have string manipulation functions, but there are third-party string libraries. You can also compare two strings by their keccak256-hash using keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2)) and concatenate two strings using bytes.concat(bytes(s1), bytes(s2)).


If you want to access the byte-representation of a string s, use bytes(s).length / bytes(s)[7] = 'x';. Keep in mind that you are accessing the low-level bytes of the UTF-8 representation, and not the individual characters.


You can concatenate a variable number of bytes or bytes1 ... bytes32 using bytes.concat. The function returns a single bytes memory array that contains the contents of the arguments without padding. If you want to use string parameters or other types, you need to convert them to bytes or bytes1/…/bytes32 first.
*/
contract C {
    bytes s = "Storage";
    function f(bytes calldata c, string memory m, bytes16 b) public view {
        bytes memory a = bytes.concat(s, c, c[:2], "Literal", bytes(m), b);
        assert((s.length + c.length + 2 + 7 + bytes(m).length + 16) == a.length);
    }
}
/*
If you call bytes.concat without arguments it will return an empty bytes array.



Fixed size memory arrays cannot be assigned to dynamically-sized memory arrays, i.e. the following is not possible:
It is planned to remove this restriction in the future, but it creates some complications because of how arrays are passed in the ABI.
If you want to initialize dynamically-sized arrays, you have to assign the individual elementsÇ:
*/
contract C {
    function f() public pure {
        uint[] memory x = new uint[](3);
        x[0] = 1;
        x[1] = 3;
        x[2] = 4;
    }
}
/*


Array slices are a view on a contiguous portion of an array. They are written as x[start:end], where start and end are expressions resulting in a uint256 type (or implicitly convertible to it). The first element of the slice is x[start] and the last element is x[end - 1].
If start is greater than end or if end is greater than the length of the array, an exception is thrown.
Both start and end are optional: start defaults to 0 and end defaults to the length of the array.
Array slices do not have any members. They are implicitly convertible to arrays of their underlying type and support index access. Index access is not absolute in the underlying array, but relative to the start of the slice.
Array slices do not have a type name which means no variable can have an array slices as type, they only exist in intermediate expressions.
As of now, array slices are only implemented for calldata arrays.
*/


function newCampaign(address payable beneficiary, uint goal) public returns (uint campaignID) {
        campaignID = numCampaigns++; // campaignID is return variable
        
        // We cannot use "campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0)"
        // because the RHS creates a memory-struct "Campaign" that contains a mapping.
        // "Right Hand Side" As in referring to the right part of the statement campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0) i.e They are saying that Campaign(beneficiary, goal, 0, 0) is creating a struct in-memory.
        
        Campaign storage c = campaigns[campaignID];
        c.beneficiary = beneficiary;
        c.fundingGoal = goal;
}
/*

You can think of mappings as hash tables, which are virtually initialised such that every possible key exists and is mapped to a value whose byte-representation is all zeros, a type’s default value. The similarity ends there, the key data is not stored in a mapping, only its keccak256 hash is used to look up the value.
Because of this, mappings do not have a length or a concept of a key or value being set, and therefore cannot be erased without extra information regarding the assigned keys (see Clearing Mappings).
Mappings can only have a data location of storage and thus are allowed for state variables, as storage reference types in functions, or as parameters for library functions. They cannot be used as parameters or return parameters of contract functions that are publicly visible. These restrictions are also true for arrays and structs that contain mappings.


For structs, it assigns a struct with all members reset. In other words, the value of a after delete a is the same as if a would be declared without assignment, with the following caveat:
delete has no effect on mappings (as the keys of mappings may be arbitrary and are generally unknown). So if you delete a struct, it will reset all members that are not mappings and also recurse into the members unless they are mappings. However, individual keys and what they map to can be deleted: If a is a mapping, then delete a[x] will delete the value stored at x.
*/

contract DeleteExample {
    uint data;
    uint[] dataArray;

    function f() public {
        uint x = data;
        delete x; // sets x to 0, does not affect data
        delete data; // sets data to 0, does not affect x
        uint[] storage y = dataArray;
        
        delete dataArray; // this sets dataArray.length to zero, but as uint[] is a complex object, also
        // y is affected which is an alias to the storage object
        // On the other hand: "delete y" is not valid, as assignments to local variables
        // referencing storage objects can only be made from existing storage objects.
        assert(y.length == 0);
    }
}

// If an integer is explicitly converted to a smaller type, higher-order bits are cut off:
uint32 a = 0x12345678;
uint16 b = uint16(a); // b will be 0x5678 now


// If an integer is explicitly converted to a larger type, it is padded on the left (i.e., at the higher order end). The result of the conversion will compare equal to the original integer:
uint16 a = 0x1234;
uint32 b = uint32(a); // b will be 0x00001234 now
assert(a == b);


// Fixed-size bytes types behave differently during conversions. They can be thought of as sequences of individual bytes and converting to a smaller type will cut off the sequence:
bytes2 a = 0x1234;
bytes1 b = bytes1(a); // b will be 0x12


// If a fixed-size bytes type is explicitly converted to a larger type, it is padded on the right. Accessing the byte at a fixed index will result in the same value before and after the conversion (if the index is still in range):
bytes2 a = 0x1234;
bytes4 b = bytes4(a); // b will be 0x12340000
assert(a[0] == b[0]);
assert(a[1] == b[1]);


// Since integers and fixed-size byte arrays behave differently when truncating or padding, explicit conversions between integers and fixed-size byte arrays are only allowed, if both have the same size. If you want to convert between integers and fixed-size byte arrays of different size, you have to use intermediate conversions that make the desired truncation and padding rules explicit:
bytes2 a = 0x1234;
uint32 b = uint16(a); // b will be 0x00001234
uint32 c = uint32(bytes4(a)); // c will be 0x12340000
uint8 d = uint8(uint16(a)); // d will be 0x34
uint8 e = uint8(bytes1(a)); // e will be 0x12


// bytes arrays and bytes calldata slices can be converted explicitly to fixed bytes types (bytes1/…/bytes32). In case the array is longer than the target fixed bytes type, truncation at the end will happen. If the array is shorter than the target type, it will be padded with zeros at the end.
contract C {
    bytes s = "abcdefgh";
    
    function f(bytes calldata c, bytes memory m) public view returns (bytes16, bytes3) {
        require(c.length == 16, "");
        bytes16 b = bytes16(m);  // if length of m is greater than 16, truncation will happen
        
        b = bytes16(s);  // padded on the right, so result is "abcdefgh\0\0\0\0\0\0\0\0"
        bytes3 b1 = bytes3(s); // truncated, b1 equals to "abc"
        
        b = bytes16(c[:8]);  // also padded with zeros
        return (b, b1);
    }
}


// Decimal and hexadecimal number literals can be implicitly converted to any integer type that is large enough to represent it without truncation:
uint8 a = 12; // fine
uint32 b = 1234; // fine
uint16 c = 0x123456; // fails, since it would have to truncate to 0x3456


// Decimal number literals cannot be implicitly converted to fixed-size byte arrays. Hexadecimal number literals can be, but only if the number of hex digits exactly fits the size of the bytes type. As an exception both decimal and hexadecimal literals which have a value of zero can be converted to any fixed-size bytes type:
bytes2 a = 54321; // not allowed
bytes2 b = 0x12; // not allowed
bytes2 c = 0x123; // not allowed
bytes2 d = 0x1234; // fine
bytes2 e = 0x0012; // fine
bytes4 f = 0; // fine
bytes4 g = 0x0; // fine


// String literals and hex string literals can be implicitly converted to fixed-size byte arrays, if their number of characters matches the size of the bytes type:
bytes2 a = hex"1234"; // fine
bytes2 b = "xy"; // fine
bytes2 c = hex"12"; // not allowed
bytes2 d = hex"123"; // not allowed
bytes2 e = "x"; // not allowed
bytes2 f = "xyz"; // not allowed


/*
As described in Address Literals, hex literals of the correct size that pass the checksum test are of address type. No other literals can be implicitly converted to the address type.

Explicit conversions from bytes20 or any integer type to address result in address payable.

An address a can be converted to address payable via payable(a).
*/
