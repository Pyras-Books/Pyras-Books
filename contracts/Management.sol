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

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Ownable.sol";
import "./Event.sol";

/// @title Contract with all functions need to manage contract
contract Management is Ownable, Event {
    /// @notice Bool to block or not contract
    /// @dev only used to disable old contract after a migration
    bool public contractEnabled = true;

    /// @notice Price of a book
    uint256 public bookPrice = 10**20;

    /// @notice Maximum number of rooted books (see whitepaper)
    uint256 public maxRootedBook = 50;

    /// @notice Address of the token used to buy books (see whitepaper)
    address public tokenAddress;

    /// @notice Token variable to call his methods
    ERC20 public token;

    /// @notice Change the address of the token contract
    /// @param _newTokenAddress new token address
    function changeTokenAddress(address _newTokenAddress) external onlyOwner {
        require(
            _newTokenAddress != address(0),
            "New token's address is invalid (= 0)"
        );
        tokenAddress = _newTokenAddress;
        token = ERC20(_newTokenAddress);
    }

    /// @notice Change the book price
    /// @param _newBookPrice new price of the book
    /// @dev only used if digits of the token change
    function changeBookPrice(uint256 _newBookPrice) external onlyOwner {
        require(bookPrice > 0, "New book price is invalid (<= 0)");
        bookPrice = _newBookPrice;
    }

    /// @notice Change the limit of rooted books
    /// @param _newMaxRootedBook new limit
    function changeMaxRootedBook(uint256 _newMaxRootedBook) external onlyOwner {
        maxRootedBook = _newMaxRootedBook;
    }

    /// @notice Change contract enabling
    /// @param _newContractEnabled new enabling value
    function changeContractEnabled(bool _newContractEnabled)
        external
        onlyOwner
    {
        contractEnabled = _newContractEnabled;
    }

    /// @notice Modifier to disable functions if contract is disabled
    modifier ContractEnabled() {
        require(
            contractEnabled == true,
            "This contract is not enabled, check if it have been migrated."
        );
        _;
    }

    /// @notice Transfer funds from contract address to owner wallet
    function withdraw(uint256 _amount) external onlyOwner {
        token.transfer(msg.sender, _amount);
    }
}
