// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentVerifier {
    struct Document {
        string title;
        uint256 size;
        uint256 publicationDate;
        bytes32 hash;
    }

    mapping(bytes32 => Document) public registeredDocuments;

    event DocumentRegistered(bytes32 indexed docHash, string title);
    event DocumentVerified(bytes32 indexed docHash, bool isValid);

    function registerDocument(
        string memory _title,
        uint256 _size,
        uint256 _publicationDate
    ) public {
        require(bytes(_title).length > 0, "Title required");
        require(_size > 0, "Size must be positive");
        require(_publicationDate > 0, "Invalid date");

        bytes32 docHash = keccak256(abi.encodePacked(_title, _size, _publicationDate));
        require(registeredDocuments[docHash].hash == 0x0, "Document already registered");

        registeredDocuments[docHash] = Document({
            title: _title,
            size: _size,
            publicationDate: _publicationDate,
            hash: docHash
        });

        emit DocumentRegistered(docHash, _title);
    }

    function verifyDocument(
        string memory _title,
        uint256 _size,
        uint256 _publicationDate
    ) public returns (bool) {
        require(bytes(_title).length > 0, "Title required");
        require(_size > 0, "Size must be positive");
        require(_publicationDate > 0, "Invalid date");
        require(_publicationDate <= block.timestamp, "Publication date cannot be in the future");

        bytes32 docHash = keccak256(abi.encodePacked(_title, _size, _publicationDate));
        bool exists = (registeredDocuments[docHash].hash != 0x0);

        emit DocumentVerified(docHash, exists);
        return exists;
    }
}
