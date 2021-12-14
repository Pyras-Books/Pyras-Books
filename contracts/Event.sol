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

/// @title Events need to keep track of actions
contract Event {
    /// @notice Event emitted during a book creation
    /// @param bookId id of the created book
    /// @param prevBookId previously referenced book id
    /// @param children number of books that had refered this book id
    /// @param profit profit generated with this book
    /// @param owner address of the owner of the book
    /// @dev some params seems usseless, but are in fact used for test
    event newBook(
        uint256 bookId,
        uint256 prevBookId,
        uint256 children,
        uint256 profit,
        address payable owner
    );

    /// @notice Event emitted when a book is updated (update of child/profit)
    /// @param bookId id of the updated book
    /// @param prevBookId previously referenced book id
    /// @param children number of books that had refered this book id
    /// @param profit profit generated with this book
    /// @param owner address of the owner of the book
    /// @dev some params seems usseless, but are in fact used for test
    event updatedBook(
        uint256 bookId,
        uint256 prevBookId,
        uint256 children,
        uint256 profit,
        address payable owner
    );

    /// @notice Event emitted when profit is added to user's wallet
    /// @param profit profit added
    /// @param guide address of the wallet
    event profit(uint256 profit, address guide);
}
