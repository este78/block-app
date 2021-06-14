var express = require('express');
var router = express.Router();

// get the index page
router.get('/', function(req, res, next) {
    // rending the helloworld.ejs and pass the name value on the page to be null
    res.render('helloworld', { 
      title: 'Hello', 
      name:null 
    });
});

// get the form_input_get route
router.get('/form_input_get', function(req, res, next) {
    // get the input from the query parameters
    var input = req.query.input

    // show the form_input_get page render the input and title variable to the page
    res.render('form_input_get', { 
        title: 'Hello', 
        input: input
      });
});

// get the factorial route
router.get('/factorial', function(req, res, next) {
    // get the input from the query url parameters
    var input = req.query.number
    // cast the input as an int
    var result = parseInt(input)
    var arr = [result, ]
    // compute the factorial i.e. 5*4*3*2*1
    for (var i = result-1; i >= 1; i--) {
        result = result * i

        // add the current multiplied number to the array
        arr.push(i)
    }

    // show the factorial page render pass the result, input and arr variables to the page
    res.render('factorial', { 
        result: result,
        input: input,
        arr: arr
    });
});

// make a post request to the index route
router.post('/', function(req, res, next) {
    // get the name variable from the body of the request
    var name = req.body.name

    // render the helloworld.ejs file and show the name variable taken as input to the page and title to be hello
    res.render('helloworld', { 
        title: 'Hello',  
        name: name
    });
});

module.exports = router;
