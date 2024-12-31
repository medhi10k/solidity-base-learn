// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract ArraysExercise {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    address[] public senders;
    uint[] public timestamps;
    uint public timestampAftery2K = 946702800;
    uint public numberAfterY2K = 0;

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    function resetNumbers() public {
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    function getCallerAddress() public view returns (address) {
        return msg.sender;
    }

    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(getCallerAddress());
        timestamps.push(_unixTimestamp);

        if (_unixTimestamp > timestampAftery2K) {
            numberAfterY2K ++;
        }
    }

    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint resultsLength = numberAfterY2K;
        uint[] memory afterY2KTimestamps = new uint[](resultsLength);
        address[] memory afterY2KSenders = new address[](resultsLength);
        uint currentIndex = 0;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > timestampAftery2K) {
                afterY2KTimestamps[currentIndex] = timestamps[i];
                afterY2KSenders[currentIndex] = senders[i];
                currentIndex ++;
            }
        }

        return (afterY2KTimestamps, afterY2KSenders);
    }

    function resetSenders() public {
        delete senders;
    }

    function resetTimestamps() public {
        delete timestamps;
    }
}