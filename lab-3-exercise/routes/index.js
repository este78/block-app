var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

/* GET home page. */
router.get('/page1', function(req, res, next) {
  res.render('page1', { title: 'Page 1' });
});

/* GET home page. */
router.get('/page2', function(req, res, next) {
  res.render('page2', { title: 'Page 2'});
});

/*random number generator 1-100*/


module.exports = router;
