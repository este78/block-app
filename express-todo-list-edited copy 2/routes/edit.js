var express = require('express');
var router = express.Router();
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

  res.render('edit', { title: 'Edit Direct', error:error, todos:todos});

});

router.get('/edit', async function(req, res, next) {
  var todo_id = req.body.todo_id.value 
  var error = null

  console.log(todo_id.value)
  
  try{
    const todoList = await TodoList.call();
    await todoList.toggleCompleted.sendTransaction(todo_id, {from: req.body.currentAcc, gas: GAS_LIMIT });
    
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
