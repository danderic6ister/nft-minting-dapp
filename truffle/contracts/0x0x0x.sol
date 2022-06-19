// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

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
    uint256 public  publicPrice = 0.02 ether ;
    // DEv sets the base uri of th collection
    string public baseURI;

    // Dev sets the TeamSupply
    uint256 public teamSupply = 10;

    // Dev sets the total amount available for airdrops 
    uint256 public amountForAirdrops = 15;

    // The MerkleRoot for Whitelisted Addresses
    bytes32 public merkleRoot;

    // Sets the max number of mint for Whitelist and PublicMint
    uint256 public maxMintForWhitelist = 2;
    uint256 public maxMintForPublicSale    = 1;

    // Sets the max number of transacions for Whitelist and Public 
    uint256 public maxTxForPublicSaleMint = 1;
    uint256 public maxTxForWhitelistMint = 1;

    // Keeps tracks of number of nfts minted in Whitelist and PublicMint
    mapping(address => uint256) public mintPerfomedInWhitelistMint;
    mapping(address => uint256) public mintPerfomedInPublicSaleMint;

    // Keeps track of number of transactions perfomed in Whitelist and PublicMint
    mapping(address => uint256) public txPerformedInWhitelisMint;
    mapping(address => uint256) public txPerformedInPublicSaleMint;

    uint256 public timeContractIsActive;
    uint256 public whitelistMintStarts = timeContractIsActive + 20;
    uint256 public whitelistMintEnds = whitelistMintStarts + 400;
    uint256 public publicMintStarts = whitelistMintEnds +20;
    bool public whitelistIsActive = false;
    bool public publicMintisActive = false;


    // Sets the name and symbol of the collection
    constructor()ERC721("x0x0x","x0x0x"){
        
    }
    // @dev checks if the contract is active 
    modifier contractIsActive(){
      require(isActive,"Contract is not yet active.");
     _;
    }
    // sets the state of the contract to true 
    function setContractActive(bool _isActive) public  onlyOwner returns(uint256){
        require(isActive == false, "Contract is already active ");
        require(_isActive,"Contract can only be set to true ");
            
        isActive = _isActive;
        timeContractIsActive = block.timestamp;
        return timeContractIsActive;

    }
    // @dev retuns Merkle root of whitelisted addresses
    function whitelistMintMerkleRoot() public view returns(bytes32){
        return merkleRoot;
    }
    
    //   @dev Owner sets the base URI of the contract
    function setBaseURI(string calldata BaseURI)public onlyOwner{
        baseURI = BaseURI;
    }
    // @dev Function returns the baseURI of the contract
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override( ERC721,ERC721Enumerable) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }
    function setPriceForPublicMint(uint256 newPrice)private contractIsActive onlyOwner {
        require(newPrice >publicPrice , "New Price must be greater than old price");
        require(newPrice < 0.05, 'new price cannot be more than 0.05 eth');
        publicPrice = newPrice;
    }
    function checksIfWhitelistMintIsActive() internal {
        if(block.timestamp > whitelistMintStarts && block.timestamp < whitelistMintEnds ){
            whitelistIsActive = true ;
        }else{
            whitelistIsActive = false;
        }
    }
    function checksIfPublicMintIsActive() internal{
        if (block.timestamp >= publicMintStarts){
            publicMintIsActive = true;
        }else{
            publicMintIsActive = false ;
        }
    }
    function whiteListMint(uint256 mintAmount,bytes32[] proof) public contractIsActive {
        checksIfWhitelistMintIsActive();
        checksIfPublicMintIsActive();

        require(isWhiteListed(proof); "You are not whitelisted to mint this nft, you can wait for public mint.")
        require(!publicMintIsActive,"Public mint is already active");
        require(whitelistIsActive,"Whitelist mint has not yet begun");
        require(mintAmount > 0, "Why would you want to mint zero nfts, don't be dumb");
        require(mintAmount <= maxMintForWhitelist, "You can't mint more than 2 in this phase");
        require(txPerformedForWhitelistMint[msg.sender] < maxTxForWhitelistMint, "You can only send one transaction from your address to this contract and you already did.");


        


    }
    function isWhiteListed(bytes32[] proof) internal returns(bool) {
        leaf = keccak256(msg.sender);
        return MerkleProof.verify(proof, MerkleRoot, leaf);


    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
     ) internal override(ERC721,ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);

       
    }

    function setBaseURI(string calldata BaseURI) public onlyOwner{
        baseURI = BaseURI;
    }
     function supportsInterface(bytes4 interfaceId) public view  override(ERC721,ERC721Enumerable) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
     ) internal  override(ERC721,ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);


    }

   
    









}