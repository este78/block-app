var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express', name:null });
});

router.post('/', function(req, res, next) {

  res.render('index', { title: 'Express', name:req.body.name });
});

router.get('/page1', function(req, res, next) {
  res.render('page1', { title: 'Express', name:null });
});

router.get('/page2', function(req, res, next) {
  res.render('page2', { title: 'Express', name:null });
});

router.get('/page3', function(req, res, next) {
  res.render('page1', { title: 'Express', name:null });
});

module.exports = router;
