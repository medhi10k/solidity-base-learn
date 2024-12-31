// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract FavoriteRecords {

    // State Variables
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) private userFavorites;
    string[] private approvedRecordList;

    // Custom Error
    error NotApproved(string albumName);

    // Constructor to initialize approvedRecords
    constructor() {
        _loadApprovedRecords();
    }

    // Load Approved Albums
    function _loadApprovedRecords() internal {
        string[9] memory records = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];

        for (uint i = 0; i < records.length; i++) {
            approvedRecords[records[i]] = true;
            approvedRecordList.push(records[i]);
        }
    }

    // Get the list of all approved records
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordList;
    }

    // Add a record to the user's favorites
    function addRecord(string memory albumName) public {
        if (!approvedRecords[albumName]) {
            revert NotApproved(albumName);
        }
        userFavorites[msg.sender][albumName] = true;
    }

    // Retrieve the list of favorites for a provided address
    function getUserFavorites(address user) public view returns (string[] memory) {
        uint count = 0;

        // Count the number of favorites for the user
        for (uint i = 0; i < approvedRecordList.length; i++) {
            if (userFavorites[user][approvedRecordList[i]]) {
                count++;
            }
        }

        // Collect the favorites into an array
        string[] memory favorites = new string[](count);
        uint index = 0;
        for (uint i = 0; i < approvedRecordList.length; i++) {
            if (userFavorites[user][approvedRecordList[i]]) {
                favorites[index] = approvedRecordList[i];
                index++;
            }
        }

        return favorites;
    }

    // Reset user favorites for the sender
    function resetUserFavorites() public {
        for (uint i = 0; i < approvedRecordList.length; i++) {
            userFavorites[msg.sender][approvedRecordList[i]] = false;
        }
    }
}