var express = require('express');
var router = express.Router();
const axios = require('axios');

const truffleContract = require('truffle-contract');

const tempContract = require('../build/contracts/TemperatureManage.json');

var Temp = truffleContract(tempContract);
Temp.setProvider("http://127.0.0.1:7545/");
var GAS_LIMIT = 1000000;

router.get('/', async function(req, res, next) {
    var temps = []
    try{
        var tempInstance = await Temp.deployed();
        temps = await tempInstance.retrieveTemp.call();
        console.log(temps)
    
      } catch(err) {
        console.log("error")
        console.log(err);
      }
    
    res.render('temp', { title: 'Temp App', temps });

});




router.post('/create', async function(req, res, next) {
    const url = "https://api.openweathermap.org/data/2.5/weather"
    
    var response = await axios.get(url, {
        params: {
            lon: -6.1544,
            lat: 53.4508,
            appid: "22aa95ccf2f1ccb0f5f8f5a9a26515d8",
            units: "metric",
        }
      })
    
    response = response.data
    
    

    var loc = response.name
    var long = Math.floor(response.coord.lon*10000);
    var lat = Math.floor(response.coord.lat*10000);
    var tempCel = Math.floor(response.main.temp*100);
    console.log(response.dt)
    var date = (new Date(response.dt*1000)).toLocaleString("en-IE");
    
    try{
        const tempInstance = await Temp.deployed();
        await tempInstance.storeTemp.sendTransaction(
            tempCel, loc, long, lat, date,
            {from: req.body.currentAcc, gas: GAS_LIMIT }
        );

    } catch(err) {
        console.log("error")
        console.log(err)
    }
    res.redirect("/temp")
    

});


module.exports = router;
