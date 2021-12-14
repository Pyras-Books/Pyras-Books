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

/// @title Book specifications and base methods
contract BookFactory {
    /// @notice Struct of a book
    /// @param bookId id of the book
    /// @param prevBookId previously referenced book id
    /// @param children number of books that had refered this book id
    /// @param profit profit generated with this book
    /// @param owner address of the owner of the book
    struct Book {
        uint256 bookId;
        uint256 prevBookId;
        uint256 children;
        uint256 profit;
        address payable owner;
    }

    /// @notice Array that store books
    Book[] internal books;

    /// @notice mapping to retrieve the books ids of an owner
    mapping(address => uint256[]) internal booksByOwner;

    /// @notice mapping to retrieve position of a book in the array "books" given his id
    mapping(uint256 => uint256) internal positionById;

    /// @notice Public getter for booksByOwner
    /// @param owner owner of the books
    /// @return array with ids of books owned by "owner"
    function getBooksByOwner(address owner)
        external
        view
        returns (uint256[] memory)
    {
        return booksByOwner[owner];
    }

    /// @notice Public getter for booksByOwner
    /// @param bookId id of the searched book
    /// @return book with the given id
    function getBookById(uint256 bookId) external view returns (Book memory) {
        require(
            positionById[bookId] != 0 || bookId == 777777777777777,
            "Book with id provided is not found."
        );
        return books[positionById[bookId]];
    }
}
