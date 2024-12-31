// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract BasicMath {

    function adder(uint _a, uint _b) public pure returns (uint sum, bool error) {
        // Check for overflow using a temporary unchecked block
        unchecked {
            uint result = _a + _b;
            // If result is less than _a, overflow occurred
            if (result < _a) {
                return (0, true);
            }
            return (result, false);
        }
    }

    function subtractor(uint _a, uint _b) public pure returns (uint difference, bool error) {
        // Check for underflow using a temporary unchecked block
        unchecked {
            // If _a is less than _b, underflow would occur
            if (_a < _b) {
                return (0, true);
            }
            return (_a - _b, false);
        }
    }
    
}