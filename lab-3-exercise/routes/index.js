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

/*page 1 form interaction*/
router.post('/page1', function(req,res,next){
  var name = req.body.name 
  var surname = req.body.surname
  var handle = req.body.handle
  console.log(name+surname+handle)
  res.render ('page1',{
    title: 'Page 1 Welcome',
    name:req.body.name,
    surname: req.body.surname,
    handle: req.body.handle
  });
});

/* GET home page. */
router.get('/page2', function(req, res, next) {
  res.render('page2', { title: 'Page 2'});
});

module.exports = router;
