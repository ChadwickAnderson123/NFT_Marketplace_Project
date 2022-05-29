// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

    // array to store our NFTs
    string [] public kryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    function mint(string memory _kryptoBird) public {
        
        // require that the _kryptoBird does not already exist
        require(!_kryptoBirdzExists[_kryptoBird], 
        'Error: kryptoBird already exists');

        // Using updated method of pushing an item into an array 
        // And returning the length of that array
        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length - 1;

        // calling the _mint() function from ERC721.sol contract
        _mint(msg.sender, _id);

        // keeping track of which NFTs have been minted
        _kryptoBirdzExists[_kryptoBird] = true;
    }

    constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {}

}
