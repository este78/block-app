var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/add', function(req, res, next) {
  var result = 0
  var {num1, num2} = req.query
  if(num1 && num2) {
      result = parseFloat(num1) + parseFloat(num2)
  }
  res.render('compute', { title: 'Add' ,result:result, num1, num2, symbol:"+" });

});

router.get('/divide', function(req, res, next) {
  var result = 0
  var {num1, num2} = req.query
  if(num1 && num2) {
    try {
      result = parseFloat(num1) / parseFloat(num2)
    } catch (e) {
      result = "error"
    }
      
  }
  res.render('compute', { title: 'divide' ,result:result, num1, num2, symbol:"/" });

});

router.get('/multiply', function(req, res, next) {
  var result = 0
  var {num1, num2} = req.query
  if(num1 && num2) {
      result = parseFloat(num1) * parseFloat(num2)
  }
  res.render('compute', { title: 'multiply' ,result:result, num1, num2, symbol:"*" });

});


router.get('/subtract', function(req, res, next) {
  var result = 0
  var {num1, num2} = req.query
  if(num1 && num2) {
      result = parseFloat(num1) - parseFloat(num2)
  }
  res.render('compute', { title: 'subtract' ,result:result, num1, num2, symbol:"-" });

});


module.exports = router;
