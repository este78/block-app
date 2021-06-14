var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/hello', function(req, res, next) {
    res.render('example', { title: 'Hello' });
});

router.get('/factorial', function(req, res, next) {
    
    res.render('factorial', { title: 'Calculate the Factorial of a number', factorial:null, initialNumber:null });
});

router.get('/another_route', function(req, res, next) {
    res.render('another_route', { title: 'Calculate the another_route of a number', factorial:null, initialNumber:null });
});

router.post('/another_route', function(req, res, next) {
    var number = req.body.x 
    console.log(number)
    res.render('another_route', { title: 'Calculate the another_route of a number', factorial:null, initialNumber:null });
});

router.post('/factorial', function(req, res, next) {
    var number = req.body.x 
    var factorial = parseInt(number)
    
    for (var i = factorial - 1; i > 0; i--) {
        factorial = factorial * i;
    }

    res.render('factorial', { 
        title: 'Calculate the Factorial of a number', factorial:factorial, 
        initialNumber:number 
    });
});

module.exports = router;
