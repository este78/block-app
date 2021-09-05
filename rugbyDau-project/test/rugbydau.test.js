const { assert } = require('chai');

const RugbyDAU = artifacts.require("./RugbyDAU.sol");
require('chai').use(require('chai-as-promised')).should()

contract("RugbyDAU", (accounts) => {
  let contract
  //before will be run first, therefore allowing the other methods to function on the deployed contract
  before(async() =>{
    contract = await RugbyDAU.deployed()
  })
  //test if the contract gets deployed properly. That is if it gets a contract address
  describe("deployment", async () => {
    it('deploys successfully', async() => {
      
      const address = contract.address
      console.log(address)
      assert.notEqual(address,"")
      assert.notEqual(address,0x0)
      assert.notEqual(address,null)
      assert.notEqual(address,undefined)
    })
    //Test the name of the contract is written 
    it("Token is named", async() => {
      const name = await contract.name()
      assert.equal(name, "RugbyDAU")
    })
    //Test the symbol in the contract is written
    it("Token is symbolised", async() => {
      const symbol = await contract.symbol()
      assert.equal(symbol, "RGBY")
    })
  })

  describe("minting", async() => {
    it('produces a new token', async () =>{
      const result = await contract.mint('#30D11C')
      const totalSupply = await contract.totalSupply()
      //success. Mint 1 token
      assert.equal(totalSupply,1)
      //write tx to console
      console.log(result)
      //find the emit in the tx
      const event = result.logs[0].args
      assert.equal(event.tokenId.toNumber(), 0,'ID is correct')
      assert.equal(event.from, '0x0000000000000000000000000000000000000000','from: just minted')
      assert.equal(event.to, accounts[0], 'recipient of token: correct')

      //failure: cannot mint the same colour twice
      await contract.mint('#30D11C').should.be.rejected;
    })

  })

  describe('indexing', async() =>{
    it('lists colors', async() =>{
      //Mint three more tokens
      await contract.mint('#d11c83')
      await contract.mint('#1cb1d1')
      await contract.mint('#f8f36b')
      const totalSupply = await contract.totalSupply()

      let color
      let result = []
      for(var i=1 ; i<=totalSupply ; i++){
        color = await contract.colors(i-1)
        result.push(color)
      }
      
      let expected = ['#30D11C','#d11c83','#1cb1d1','#f8f36b']
      assert.equal(result.join(','), expected.join(','), 'Colors are stored')
    })
  })

});
