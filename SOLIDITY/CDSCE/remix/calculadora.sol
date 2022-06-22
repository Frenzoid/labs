// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/// @author Frenzoid
contract Calculadora {
    uint[] numeros;

    modifier esMayor(uint mayor, uint menor) {
        require(mayor > menor, "El numero no es mayor.");
        _;
    }

    function suma(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    function resta(uint a, uint b) public pure esMayor(a, b) returns (uint) {
        return a - b;
    }

    function potencia10a8(uint a) public pure returns (uint) {
        return a * 10**8;
    }

    function guardarNumero(uint a) public returns (uint[] memory) {
        numeros.push(a);
        return numeros;
    }
}
