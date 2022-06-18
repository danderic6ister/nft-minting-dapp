// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "./node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./node_modules/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract x0x0x is ERC721,ERC721Enumerable,Ownable{
    // Returns whether or not the contract is active 
    bool    public isActive = false ;
    // Tracks the state of the whitelistMint and PublicMint
    bool public whitelistMintIsActive = false;
    bool public publicMintIsActive = false;

    // @dev Sets the total Supply of the NFT collection 
    uint256 public maxSupply = 200;
    // Dev Sets the price of whitelist sale
    uint256 public immutable whitelistPrice = 0.01 ether;
    // Dev sets the price of Public Sale 
    uint256 public publicPrice = 0.02 ether ;
    // DEv sets the base uri of th collection
    string public baseURI;

    // Dev sets the TeamSupply
    uint256 public teamSupply = 10;

    // Dev sets the total amount available for airdrops 
    uint256 public amountForAirdrops = 15;

    // The MerkleRoot for Whitelisted Addresses
    bytes32 public merkleRoot;

    // Sets the max number of mint for Whitelist and PublicMint
    uint256 public maxMintForWhitelistMint = 2;
    uint256 public maxMintForPublicSaleMint    = 1;

    // Sets the max number of transacions for Whitelist and Public 
    uint256 public maxTxForPublicSaleMint = 1;
    uint256 public maxTxForWhitelistMint = 1;

    // Keeps tracks of number of nfts minted in Whitelist and PublicMint
    mapping(address => uint256) public mintPerfomedInWhitelistMint;
    mapping(address => uint256) public mintPerfomedInPublicMint;

    // Keeps track of number of transactions perfomed in Whitelist and PublicMint
    mapping(address => uint256) public txPerformedInWhitelist;
    mapping(address => uint256) public txPerformedInPublicSaleMint;

    uint256 public timeContractIsActive;



    // Sets the name and symbol of the collection
    constructor()ERC721("x0x0x","x0x0x"){
        
    }
    // sets the state of the contract to true 
    function setContractActive(bool _isActive) public  onlyOwner returns(uint256 memory){
        require(_isActive);
       isActive = _isActive;
       timeContractIsActive = block.timestamp;
       return timeContractIsActive;

    }

    function setBaseURI(string calldata _baseURI) onlyOwner{
        baseURI = _baseURI;
    }

   
    









}