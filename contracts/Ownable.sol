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

/// @title Contract that implements access restrictions
contract Ownable {
    /// @notice address of the owner of the contract
    address public owner;

    /// @notice Event emited when ownership is transferred
    /// @param previousOwner previous owner
    /// @param newOwner new owner
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /// @notice constructor sets the original "owner" of the contract to the sender account.
    constructor() {
        owner = msg.sender;
    }

    /// @notice Modifier that throw error if function isn't called by owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Message sender is not the owner.");
        _;
    }

    /// @notice Allows the current owner to transfer ownership of the contract to a new owner
    /// @param newOwner address of the new owner of the contract
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner's address is invalid (= 0)");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
