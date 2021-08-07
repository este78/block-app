var express = require('express');
var router = express.Router();
var ethJSABI = require("ethjs-abi");
var BlockchainUtils = require("truffle-blockchain-utils");
const truffleContract = require('truffle-contract');
var jwt = require('jsonwebtoken');

var Web3 = require("web3");
var sqlite = require("better-sqlite3");
var cookie = require('js-cookie');

const bookListContract = require('../build/contracts/BookList.json');

var BookList = truffleContract(bookListContract);
BookList.setProvider("http://127.0.0.1:7545/");
var GAS_LIMIT = 1000000;


router.get('/', async function (req, res, next) {
  var error = req.query.error;
  var books = []
  var token = req.cookies.token
  var user_id = null
  try {
    user_id = await jwt.verify(token, "SECRET_KEY" + req.query.address).user_id;
  } catch (error) {
    console.log(error)
    return res.redirect("/users/logout")
  }


  var db = new sqlite('database.db');
  var user = await db.prepare('SELECT * FROM users where address = (?)').get(req.query.address);
  if(user.id != user_id)  {
    return res.redirect("/users/logout")
  }
  try {
    var bookList = await BookList.deployed();
    bookListSol = await bookList.getAll.call();
    for (let i = 0; i < bookListSol.length; i++) {
      console.log(bookListSol[i][2] == user.id)
      if (bookListSol[i][2] == user.id) {
        books.push(bookListSol[i])
      }
    }

  } catch (err) {
    console.log("error")
    console.log(err);
  }

  res.render('index', { title: 'BookList', error: error, books: books });
});


router.post('/add', async function (req, res, next) {
  var book_name = req.body.book_name
  var error = null

  var token = req.cookies.token
  var user_id = null

  try {
    user_id = await jwt.verify(token, "SECRET_KEY" + req.body.currentAcc).user_id;
    

  } catch (error) {
    console.log(error)
    res.redirect("/users/logout")
  }


  if (book_name) {
    try {
      var db = new sqlite('database.db');
      var user = await db.prepare('SELECT * FROM users where address = (?)').get(req.body.currentAcc);
      if(user.id != user_id)  {
        return res.redirect("/users/logout")
      }


      const bookList = await BookList.deployed();
      console.log(book_name, user.id)
      await bookList.newBook.sendTransaction(book_name, user.id, { from: req.body.currentAcc, gas: GAS_LIMIT });

      res.redirect("/?address=" + req.body.currentAcc)
      return
    } catch (err) {
      console.log("error")
      console.log(err)
      error = err
    }

  } else {
    error = "Specify a name for a book"
  }
  error = ""
  res.redirect('/?error=' + encodeURIComponent(error) + "&address=" + req.body.currentAcc);

});

router.get('/edit', function (req, res, next) {
  if (!req.query.book_id) {
    return res.redirect("/?address=" + req.query.currentAcc)
  }

  res.render('edit', { title: 'Book list', book: req.query.book_name, book_id: req.query.book_id });
});

router.post('/edit', async function (req, res, next) {
  if (!req.body.book_id) {
    return res.redirect("/?address=" + req.query.currentAcc)
  }

  var user_id
  var { book_name, book_id, currentAcc } = req.body
  var token = req.cookies.token
  try {
    user_id = await jwt.verify(token, "SECRET_KEY" + currentAcc).user_id;
  } catch (error) {
    console.log(error)
    return res.redirect("/users/logout")
  }

  try {
    var db = new sqlite('database.db');
    var user = await db.prepare('SELECT * FROM users where address = (?)').get(currentAcc);
    if(user.id != user_id)  {
      return res.redirect("/users/logout")
    }
    const bookList = await BookList.deployed();
    await bookList.editBook.sendTransaction(book_id, book_name, user.id, { from: currentAcc, gas: GAS_LIMIT });

  } catch (err) {
    console.log(err)
    return res.redirect("/edit?address=" + req.body.currentAcc + "&book_id=" + book_id)
  }
  return res.redirect("/?address=" + req.body.currentAcc)
});




module.exports = router;
