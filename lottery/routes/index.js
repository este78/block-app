var express = require('express');
var router = express.Router();

var ethJSABI = require("ethjs-abi");
var BlockchainUtils = require("truffle-blockchain-utils");
const truffleContract = require('truffle-contract');

var Web3 = require("web3");

const lotteryContract = require('../build/contracts/Lottery.json');
const { ethers } = require('ethers');

var Lottery = truffleContract(lotteryContract);
Lottery.setProvider("http://127.0.0.1:7545/");
var GAS_LIMIT = 1000000;

/* GET home page. */
router.get('/', async function(req, res, next) {

  var error = req.query.error;
  var draws = []

  try{
    var lottery = await Lottery.deployed();
    draws = await lottery.getAllDraws.call();


  } catch(err) {
    console.log("error")
    console.log(err);
  }

  res.render('index', { title: 'Prime Lottery', error:error, draws:draws });
});
//Draws a number after paying a fee of 10
router.post('/add', async function(req, res, next) {
  var error = null
 
    try{
      const lottery = await Lottery.deployed();
      await lottery.tryYourLuck.sendTransaction({value: "10000000000000000", from: req.body.currentAcc, gas: GAS_LIMIT });
      
      res.redirect("/")
      return

    } catch(err) {
      console.log("error")
      console.log(err)
      error = err
    }

  res.redirect('/?error=' + encodeURIComponent(error));
  
});


module.exports = router;
