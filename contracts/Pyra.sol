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

import "./Management.sol";
import "./Utils.sol";

/// @title Main contract of Pyra
contract Pyra is Management, Utils {
    
    /// @notice distribution between guides
    uint16[] private commission = [
        600,
        200,
        50,
        20,
        15,
        14,
        13,
        12,
        11,
        10,
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1
    ];

    /// @notice Create root book (Ra's book)
    /// @param _rootGuide address of root book owner
    /// @dev Id of root book is always 777777777777777
    function createRootBook(address payable _rootGuide) external onlyOwner {
        require(
            _rootGuide != address(0),
            "Address of root guide is invalid (= 0)."
        );

        books.push(Book(777777777777777, 777777777777777, 0, 0, _rootGuide));
        booksByOwner[_rootGuide].push(777777777777777);
        positionById[777777777777777] = 0;

        emit newBook(
            books[0].bookId,
            books[0].prevBookId,
            books[0].children,
            0,
            _rootGuide
        );
    }

    /// @notice Create a book buy by msg.sender
    /// @param _prevBookId id entred by user
    /// @param _quantity quantity of book bought
    /// @dev This function interract with the token contract setup in Management.sol
    function buyBook(uint256 _prevBookId, uint256 _quantity)
        external
        payable
        ContractEnabled
    {
        require(_prevBookId >= 0, "Previous book id is invalid (< 0).");
        require(_quantity > 0, "Quantity is invalid (<= 0).");
        require(
            positionById[_prevBookId] != 0 || _prevBookId == 777777777777777,
            "Previous book with id provided is not found."
        );

        if (_prevBookId == 777777777777777) {
            require(
                books[0].children + _quantity <= maxRootedBook,
                "Rooted books are not yet available."
            );
        }

        require(
            token.allowance(msg.sender, address(this)) >= bookPrice * _quantity,
            "Not enougth founds are allowed to contract."
        );

        require(
            token.transferFrom(
                msg.sender,
                address(this),
                bookPrice * _quantity
            ),
            "Unable to pay contract"
        );

        transfertToGuides(_prevBookId, _quantity);

        for (uint256 i = 0; i < _quantity; ++i) {
            createNewBook(_prevBookId);
        }
    }

    /// @notice Distribute investisment between guides
    /// @param _bookId id of the first book that need profit
    /// @param _quantity quantity of book bought
    /// @dev stop if root book is reached
    function transfertToGuides(uint256 _bookId, uint256 _quantity) private {
        uint256 pool = (bookPrice * _quantity * 99) / 100;

        Book memory guideBook = books[positionById[_bookId]];
        address payable guide = guideBook.owner;

        for (uint16 i = 0; i < 19; ++i) {
            uint256 guideCommission = (bookPrice * commission[i] * _quantity) /
                1000;

            require(
                token.transfer(guide, guideCommission),
                "Unable to pay all guides"
            );
            pool -= guideCommission;
            books[positionById[guideBook.bookId]].profit += guideCommission;
            emit profit(guideCommission, guide);

            if (
                guideBook.bookId == 777777777777777 &&
                guideBook.prevBookId == 777777777777777
            ) {
                token.transfer(msg.sender, pool);
                return;
            }
            guideBook = books[positionById[guideBook.prevBookId]];
            guide = guideBook.owner;
        }
    }

    /// @notice Create a new book
    /// @param _prevBookId id of the previous book
    /// @dev use events to track creation
    function createNewBook(uint256 _prevBookId) private {
        uint256 bookId = generateRandomId();
        positionById[bookId] = books.length;
        books.push(Book(bookId, _prevBookId, 0, 0, payable(msg.sender)));

        books[positionById[_prevBookId]].children =
            books[positionById[_prevBookId]].children +
            1;
        booksByOwner[msg.sender].push(bookId);

        emit newBook(
            bookId,
            books[positionById[bookId]].prevBookId,
            books[positionById[bookId]].children,
            books[positionById[bookId]].profit,
            payable(msg.sender)
        );

        emit updatedBook(
            books[positionById[_prevBookId]].bookId,
            books[positionById[_prevBookId]].prevBookId,
            books[positionById[_prevBookId]].children,
            books[positionById[_prevBookId]].profit,
            books[positionById[_prevBookId]].owner
        );
    }

    /// @notice Save books for possible migration
    /// @return all books created
    /// @dev Only created books are needed to make a migration
    function saveBooks() external view onlyOwner returns (Book[] memory) {
        return books;
    }
}
