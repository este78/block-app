var express = require('express');
var router = express.Router();
var ethJSABI = require("ethjs-abi");
var BlockchainUtils = require("truffle-blockchain-utils");
const truffleContract = require('truffle-contract');

var Web3 = require("web3");


const todoListContract = require('../build/contracts/TodoList.json');

var TodoList = truffleContract(todoListContract);
TodoList.setProvider("http://127.0.0.1:7545/");
var GAS_LIMIT = 1000000;


router.get('/', async function(req, res, next) {
  var error = req.query.error;
  var todos = []

  try{
    var todoList = await TodoList.deployed();
    todos = await todoList.getAll.call();


  } catch(err) {
    console.log("error")
    console.log(err);
  }

  res.render('index', { title: 'TodoList', error:error, todos:todos });


});

router.post('/add', async function(req, res, next) {
  var todo_content = req.body.task
  var error = null

  console.log(todo_content)
  if(todo_content) {
    try{
      const todoList = await TodoList.deployed();
      await todoList.createTask.sendTransaction(todo_content, {from: req.body.currentAcc, gas: GAS_LIMIT });
      
      res.redirect("/")
      return

    } catch(err) {
      console.log("error")
      console.log(err)
      error = err
    }
    
  } else {
    error = "Todo had no content"
  }

  res.redirect('/?error=' + encodeURIComponent(error));
  
});

module.exports = router;
