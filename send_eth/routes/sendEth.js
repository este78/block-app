var express = require('express');
var Tx = require('ethereumjs-tx').Transaction

var router = express.Router();
const Web3 = require('web3')
const rpcURL = 'http://127.0.0.1:7545/'
const web3 = new Web3(rpcURL)

// private key: a1febe107b306b28ff46dcf3b631cc0b852dce63f9142194f942eb61489f96d5
// my id: 0xB3f8c6274EcF67bBB1251A79Bf5a6351e36C01D1
// to id: 0x3686B3717da0bb27a9583f1462002239270da714

router.post('/', async function(req, res, next) {
  var { privateKey, fromAddress, toAddress, amount } = req.body
  var gasPrice = '2';
  var gasPriceEth = web3.utils.fromWei(gasPrice, 'ether');
  var gasLimit = 3000000;

  try {
    var privateSerialisedKey = Buffer.from(privateKey, 'hex');
    var rawTx = {
      nonce: await web3.eth.getTransactionCount(fromAddress),
      gasPrice: web3.utils.numberToHex(gasPrice),
      gasLimit: web3.utils.numberToHex(gasLimit),
      to: toAddress,
      value: web3.utils.numberToHex(web3.utils.toWei(amount, 'ether'))
    }

    var tx = new Tx(rawTx, {'chain':'ropsten'});
    tx.sign(privateSerialisedKey);
    var serializedTx = tx.serialize();

    var transactionStatus =  (await web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex'))).status

    if(transactionStatus) {
      res.render('sendEth', { title: 'Your transaction was successful', gasPrice: gasPriceEth });
      return
    }
    
  } catch (error) {
    console.log(error)
  }

  res.render('sendEth', { title: 'Error your transaction failed', gasPrice: gasPriceEth });
});

router.get('/', async function(req, res, next) {
  var gasPrice = '2';
  var gasPriceEth = web3.utils.fromWei(gasPrice, 'ether');
  
  
  res.render('sendEth', { title: 'Send some ETH', gasPrice: gasPriceEth });
});

module.exports = router;
