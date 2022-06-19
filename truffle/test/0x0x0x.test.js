/**
 *
 * autogenerated by solidity-visual-auditor
 *
 * execute with:
 *  #> truffle test <path/to/this/test.js>
 *
 * */
var x0x0x = artifacts.require(
  'c:UsersDaniel AwodejiDesktop\nft-minting-dapp\trufflecontracts\0x0x0x.sol'
);

contract('x0x0x', (accounts) => {
  var creatorAddress = accounts[0];
  var firstOwnerAddress = accounts[1];
  var secondOwnerAddress = accounts[2];
  var externalAddress = accounts[3];
  var unprivilegedAddress = accounts[4];
  /* create named accounts for contract roles */

  before(async () => {
    /* before tests */
  });

  beforeEach(async () => {
    /* before each context */
  });

  it('should revert if ...', () => {
    return x0x0x
      .deployed()
      .then((instance) => {
        return instance.publicOrExternalContractMethod(argument1, argument2, {
          from: externalAddress,
        });
      })
      .then((result) => {
        assert.fail();
      })
      .catch((error) => {
        assert.notEqual(error.message, 'assert.fail()', 'Reason ...');
      });
  });

  context('testgroup - security tests - description...', () => {
    //deploy a new contract
    before(async () => {
      /* before tests */
      const newx0x0x = await x0x0x.new();
    });

    beforeEach(async () => {
      /* before each tests */
    });

    it('fails on initialize ...', async () => {
      return assertRevert(async () => {
        await newx0x0x.initialize();
      });
    });

    it('checks if method returns true', async () => {
      assert.isTrue(await newx0x0x.thisMethodShouldReturnTrue());
    });
  });
});