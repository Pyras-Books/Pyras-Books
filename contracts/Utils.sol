// SPDX-License-Identifier: Apache License 2.0
// Copyright 2021 Ra
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

pragma solidity 0.8.10;

import "./BookFactory.sol";
import "./Event.sol";

/// @title Some utils methods
contract Utils is BookFactory, Event {

    /// @notice random seed for id generator
    uint256 private randSeed = 0;

    /// @notice Getter for numbers of books created
    /// @return number of books created
    function getBookCount() public view returns (uint256) {
        return books.length;
    }

    /// @notice Generate a random id
    /// @return random id generated
    /// @dev Custom generation, gessing is not important 
    function generateRandomId() internal returns (uint256) {
        randSeed++;
        uint256 randId = uint256(
            keccak256(
                abi.encode(
                    block.timestamp,
                    msg.sender,
                    randSeed,
                    books[0].children
                )
            )
        ) % (10**15);
        if (positionById[randId] != 0 && randId != 777777777777777) {
            return generateRandomId();
        }
        return randId;
    }
}
