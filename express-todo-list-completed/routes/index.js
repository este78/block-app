var express = require('express');
var router = express.Router();
var ethJSABI = require("ethjs-abi");
var BlockchainUtils = require("truffle-blockchain-utils");
const truffleContract = require('truffle-contract');

var Web3 = require("web3");
var sqlite = require("better-sqlite3");

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


router.get('/edit', function(req, res, next) {
  if(!req.query.todo_id) {
    res.redirect("/")
  }
  
  res.render('edit', { title: 'Todo list', todo:req.query.content, todo_id:req.query.todo_id, completed:req.query.completed });
});

router.post('/edit', async function(req, res, next) {
  if(!req.body.todo_id) {
    res.redirect("/")
    return
  }
  var { task, completed, originalCompleted, todo_id, currentAcc } = req.body
  console.log(req.body)
  try {
    const todoList = await TodoList.deployed();
    await todoList.editTask.sendTransaction(todo_id, task, {from: currentAcc, gas: GAS_LIMIT });

    if(Boolean(completed) != Boolean(JSON.parse(originalCompleted))) {
      await todoList.toggleCompleted.sendTransaction(todo_id, {from: currentAcc, gas: GAS_LIMIT });
    }

  } catch(err) {
    console.log(err)
  }


  res.redirect("/")
});




module.exports = router;
