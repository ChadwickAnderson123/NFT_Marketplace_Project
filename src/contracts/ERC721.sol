// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';


/*
Important to Remember!

    Building out the minting function:
        a. nft points to an address
        b. keep track of the token IDs
        c. keep track of token owner addresses to token IDs
        d. keep track of how many tokens each address has
        e. create an event that emits a transfer log -
        the contract address where it is minted to
*/

contract ERC721 is ERC165, IERC721 {

    // Mapping from token ID to the owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _OwnedTokensCount;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

     constructor() {
        _registerInterface(bytes4(
        keccak256('balanceOf(address)')^
        keccak256('ownerOf(uint256)')^
        keccak256('transferFrom(address, address, uint256)')));
    }

    function balanceOf(address _owner) public override view returns(uint256) {
        require(_owner != address(0), 'owner query for nonexistent token');
        return _OwnedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public override view returns(address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for nonexistent token');
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        
        // setting the address of NFT owner to check the mapping
        // of the address from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];

        //returns truthiness that the address is not 0
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
       
        // requires that the address isn't zero
        require(to != address(0), 'ERC721: minting to the zero address');

        // requires that the token does not already exist
        require(!_exists(tokenId), 'ERC721: token already minted');
        
        // we are adding a new address with a tokenId for minting
        _tokenOwner[tokenId] = to;

        // keeping track of each address that is minting and adding one to the count
        _OwnedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        
        // requires that the address receiving the token is not a zero address
        require(_to != address(0), 'Error - ERC721 transfer to the zero address');

        // requires that the address transferring the token actually owns the token
        require(ownerOf(_tokenId) == _from, 'Error - trying to transfer a token the address does not own');

        // updates the balance of the _from address
        _OwnedTokensCount[_from] -= 1;

        // updates the balance of the _to address 
        _OwnedTokensCount[_to] += 1;

        // adds the token ID to the address receiving the token
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        _transferFrom(_from, _to, _tokenId);
    }

    // require that the person approving is the owner
    // make sure that we are approving an address to a token
    // require that we cant approve sending tokens of the owner to the owner
    // update the map of the approval addresses

    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Error - current caller is not the owner of the token');
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

}