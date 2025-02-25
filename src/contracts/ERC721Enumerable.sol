// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    uint256[] private _allTokens;

    // mapping from tokneId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from tokenId to index of the owner token list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  sthem has an assigned and queryable owner not equal to the zero addres
    function totalSupply() public override view returns(uint256) {
        return _allTokens.length;
    }

    // /// @notice Enumerate valid NFTs
    // /// @dev Throws if `_index` >= `totalSupply()`.
    // /// @param _index A counter less than `totalSupply()`
    // /// @return The token identifier for the `_index`th NFT,
    // ///  (sort order not specified)
    // function tokenByIndex(uint256 _index) external view returns (uint256) {

    // }

    // /// @notice Enumerate NFTs assigned to an owner
    // /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    // ///  `_owner` is the zero address, representing invalid NFTs.
    // /// @param _owner An address where we are interested in NFTs owned by them
    // /// @param _index A counter less than `balanceOf(_owner)`
    // /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    // ///   (sort order not specified)
    // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
        
    // }

    function _mint(address to, uint tokenId) internal override(ERC721) {
        super._mint(to, tokenId);

        // 2 things!
        // a. add tokens to the owner
        // b. all tokens to our totalSupply - to allTokens

        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    // add tokens to the _allTokens array and set the position of the tokens indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {

        // 1. add address and tokenId to the _ownedTokens
        // 2. ownedTokensIndex tokenId set to address of ownedTokens position
        // 3. we want to execute the function with minting

        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);

    }

    function tokenByIndex(uint256 index) public override view returns(uint256) {
        // make sure that the index is not out of bounds of  the total supply
        require (index < totalSupply(), 'global index is out of bounds!');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public override view returns(uint256) {
        require(index < balanceOf(owner), 'global index is out of bounds!');
        return _ownedTokens[owner][index];
    }


}