// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";





contract x0x0x is ERC721,ERC721Enumerable,Ownable{
    /**  @dev Returns whether or not the contract is active */
    bool    public isActive ;

    /**  Tracks the state of the whitelistMint and PublicMint */

    /**  @dev Sets the total Supply of the NFT collection  */
    uint256 public maxSupply = 200;

    /**  @dev Sets the price of whitelist sale */
    uint256 public  whitelistPrice = 0.01 ether;

    /**  @dev sets the price of Public Sale  */ 
    uint256 public  publicPrice = 0.02 ether ;

    /**  @dev sets the base uri of th collection */
    string public baseURI;

    /**  @dev sets the base uri of the collection  */
    uint256 public teamSupply = 20;

    /**  @dev sets the total amount available for airdrops  */
    uint256 public amountForAirdrops = 15;

    /**  @dev sets the MerkleRoot for Whitelisted Addresses */
    bytes32 public merkleRoot;

    /**  @dev  Sets the max number of mint for Whitelist and PublicMint */
    uint256 public maxMintForWhitelist = 2;
    /**
         @dev Could have been useful if maxMint for public was more than 1
      
    // uint256 public maxMintForPublic  = 1;
    */

    /**  @dev Sets the max number of transacions for Whitelist and Public  */ 
   
    uint256 public maxTx= 1;
    

    /**  @dev Keeps tracks of number of nfts minted in Whitelist and PublicMint  */
    mapping(address => uint256) public mintPerformedInWhitelistMint;
    mapping(address => uint256) public mintPerformedInPublicSaleMint;

    /**  @dev Keeps track of number of transactions perfomed in Whitelist and PublicMint  */
    mapping(address => uint256) public txPerformedInWhitelistMint;
    mapping(address => uint256) public txPerformedInPublicSaleMint;


    /**  @dev Initializes the time the contract is deployed and hardcodes it for other variables  */
    uint256 public timeContractIsActive = block.timestamp ;
    uint256 public whitelistMintStarts = timeContractIsActive + 20;
    uint256 public whitelistMintEnds = whitelistMintStarts + 200;
    uint256 public publicMintStarts = whitelistMintEnds +20;

    bool public whitelistIsActive = false;
    bool public publicMintIsActive = false;
    bool public teamHasClaimed ;


    /** @dev Sets the name and symbol of the collection */ 
    constructor()ERC721("x0x0x","x0x0x") {}

    /** @dev checks if the contract is active  */
    modifier contractIsActive(){
      require(isActive,"Contract is not yet active.");
     _;
    }
    /** @dev retuns Merkle root of whitelisted addresses */
    function whitelistMintMerkleRoot() public view returns(bytes32){
        return merkleRoot;
    }
    /**  @dev sets the merkleroot of whitelisted addresses  */
    function setWhitelistRoot(bytes32 _whitelistRoot) public onlyOwner {
        merkleRoot = _whitelistRoot;
    }
    /**  @dev verifies if wallet is whitelisted */  
    function isWhiteListed(bytes32[] calldata proof) view internal returns(bool) {
       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }
    
    /**  @dev Owner sets the base URI of the contract */ 
    function setBaseURI(string calldata BaseURI)public onlyOwner{
        baseURI = BaseURI;
    }
    /**  @dev Function returns the baseURI of the contract */
   function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

  /**   @dev function checks is the time for whitelistmint is up.
        function is called before every mint to check the state of the contract.
        
 */
    function checksIfWhitelistMintIsActive() internal {
        if(block.timestamp > whitelistMintStarts && block.timestamp < whitelistMintEnds ){
            whitelistIsActive = true ;
        }else{
            whitelistIsActive = false;
        }
    }
    /**   @dev function checks is the time for PublicMint is up.
        function is called before every mint to check the state of the contract.
        
 */
    function checksIfPublicMintIsActive() internal{
        if (block.timestamp >= publicMintStarts){
            publicMintIsActive = true;
        }else{
            publicMintIsActive = false ;
        }
    }

    /** @dev mints the team supply to thier wallet.
        The team needs to mint to treasury after which the contract becomes active */

    function mintToTeam() public onlyOwner {
        require(!teamHasClaimed, "You have claimed already.");
        require(!isActive , "The contract is already active.");
        
        for(uint i =0 ; i< teamSupply; i++){
            _mint(msg.sender, totalSupply() +1);
        }
        teamHasClaimed = true;
        

        isActive = true;

    }
    /**  @dev Allows owner ot change the price for publicSale recall the mint price for whitelist mint is immutable .
              also converts inputted price to solidity's standard.
              Ensures the upper value of price change does not exceed 0.05eth  */
    function setPriceForPublicMint(uint256 newPrice)private contractIsActive onlyOwner {
        uint256 newPriceInSolidity = newPrice * 100;
        uint256 value = 5;
        uint upperPriceLimit = value/100;

       
        require(newPriceInSolidity /100 > publicPrice , "New Price must be greater than old price");
        require(newPriceInSolidity /100  < upperPriceLimit , 'new price cannot be more than 0.05 eth');
        publicPrice = newPrice;
    }
    /**  @dev allows the public to mint after a certain time.
            Checks if the contract is active , which can only be after the team has minted.
            Checks if wl mint is active, reverts if true .
            Also checks if public mint is active , reverts if false.
            Requires the mint amount to be equal to 1.
            Checks if wallet has sent a transaction exceeding the max,reverts if true.
            checks if the minter is sending the right amount of ether to contract,reverts if false.
            Checks if the the amount to be minted and the current supply does not cause an overflow.
            mints the amount,uses the current totalSupply before mint as the id of the token to be minted.
            increments the tx performed in the mint phase.
            increments the mints perforemd in this phase

     */
    function publicMint(uint256 mintAmount) public payable contractIsActive {
         checksIfWhitelistMintIsActive();
         checksIfPublicMintIsActive();
         require(!whitelistIsActive,"Whitelsit mint is still active.");
         require(publicMintIsActive,"Public mint has not yet begun.");
        //  @dev If you plan to mint more than 1 nfts in your public mint. Front end logic should cove rthus , but what if we mint from contract.
        //  require(mintAmount > 0,"dumbass , you can't mint zero nfts.");

        // @dev require mintAmount to be compulsorily equal to 1 because i dotn want more than 1 to be minted in this phase.
         require(mintAmount == 1,"You cant mint more  or less than 1 nft");
        //  require(mintPerfomedInPublicSaleMint[msg.sender]< 1,"You can only perform1 mint ")
         require(txPerformedInPublicSaleMint[msg.sender] <maxTx,"You can onlt send one transaction from your address and you already did.");
         require(publicPrice *mintAmount >= msg.value,"the amount you are abount to send is lees than what you should pay.");
         require(totalSupply() <= maxSupply-amountForAirdrops, "Minted Out" );
         _mint(msg.sender,totalSupply() +1);

         txPerformedInPublicSaleMint[msg.sender] ++;
         mintPerformedInPublicSaleMint[msg.sender] ++;


    } /**  @dev    allows the whitelisted addresses  to mint after a certain time.
                Checks if the contract is active , which can only be after the team has minted.
               checks if wallet is whitelisted.
               Checks if wl mint is active, reverts if false .
               Also checks if public mint is active , reverts if true.
               Requires the mint amount to be equal to 1.
               Checks if wallet has sent a transaction exceeding the max,reverts if true.
               checks if the minter is sending the right amount of ether to contract,reverts if false.
               Checks if the the amount to be minted and the current supply  causes an overflow.
               -mints the amount,uses the current totalSupply before mint as the id of the token to be minted.
               increments the tx performed in the mint phase.
               increments the mints perforemd in this phase(could be useful for future airdrops)

     */
    function whiteListMint(uint256 mintAmount,bytes32[] calldata proof) public payable contractIsActive {
        checksIfWhitelistMintIsActive();
        checksIfPublicMintIsActive();

        require(isWhiteListed(proof), "You are not whitelisted to mint this nft, you can wait for public mint.");
        require(!publicMintIsActive,"Public mint is already active");
        require(whitelistIsActive,"Whitelist mint has not yet begun");
        require(mintAmount > 0, "Why would you want to mint zero nfts, don't be dumb");
        require(mintAmount <= maxMintForWhitelist, "You can't mint more than 2 in this phase");
        require(mintPerformedInWhitelistMint[msg.sender] < maxMintForWhitelist, "You can only mint a max of 2 nfts  and you already did.");
        require(txPerformedInWhitelistMint[msg.sender] < maxTx , "You can only send one transaction from your address to this contract and you already did.");
        require(whitelistPrice * mintAmount >= msg.value , "The amount you are about to send is less than what you should pay.");
        require(totalSupply()  <= maxSupply - amountForAirdrops, "Minted out.");
        
        for (uint256 i = 0; i<mintAmount; i++){

            _mint(msg.sender, totalSupply() +1);

        }
        txPerformedInWhitelistMint[msg.sender] ++;
        
        mintPerformedInWhitelistMint[msg.sender] += mintAmount;

    }
  
  
  /** @dev withdraws funds from contract  */
    function withdraw() public payable onlyOwner{
        // address ContractOwner = msg.sender;
        address owner_ = owner() ;

        payable(owner_).transfer(address(this).balance);

    } 

    

  /**@dev Airdrops to selected account */
    function airdrop (address to)  public onlyOwner{
        require( amountForAirdrops >= 1, "You can't airdrop anymore tokens.");
        _mint(to,totalSupply()+1);
        amountForAirdrops -= 1;
    }
  /** @dev routine  implementation for inheriting from  ERC721Enumerable.sol */  

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
     ) internal override(ERC721,ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);

       
    }

   
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

   

   
    









 }
// /**
// [
//   "0xd8d21303ee4c21f0079ae1976c52866e0860b24fad2110d44ea9504486eecf33",
//   "0xe48e16d82c4a66e30ba3a731d1df05af5a006c954e90512805f233ff2b6bfc1d"
// ]
// [
//   "0xed20234281228b5eff2144333de9667d881943134261bffae730cb6618925ca3",
//   "0x5ee6d1aa97362b65082e32f95317840d66096b7aaf06db0ed750e9f2ca114108",
//   "0x493bea813a8507332859e614b54c863b040f254076059d24296275045ca7c41d"
// ]

// 222
// [
//   "0x96fddd347239aefee3d37007c6270bcea710d334f3fc8653fd2447f4898398a0",
//   "0x5ee6d1aa97362b65082e32f95317840d66096b7aaf06db0ed750e9f2ca114108",
//   "0x493bea813a8507332859e614b54c863b040f254076059d24296275045ca7c41d"
// ]











