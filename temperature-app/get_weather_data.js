const axios = require('axios');
const truffleContract = require('truffle-contract');

const tempContract = require('./build/contracts/TemperatureManage.json');

var Temp = truffleContract(tempContract);
Temp.setProvider("http://127.0.0.1:7545/");
var GAS_LIMIT = 1000000;

function waitTime() {
  return new Promise(
    function(resolve) {
      return setTimeout(resolve, 1000*60*60*24)
    })
}


async function getWeatherDataCallback() {
    while(true) {
        await waitTime()
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
        var date = (new Date(response.dt*1000)).toLocaleString("en-IE");
        
        try{
            const tempInstance = await Temp.deployed();
            await tempInstance.storeTemp.sendTransaction(
                tempCel, loc, long, lat, date,
                {from: "0xB3f8c6274EcF67bBB1251A79Bf5a6351e36C01D1", gas: GAS_LIMIT }
            );

        } catch(err) {
            console.log("error")
            console.log(err)
        }
  }
}

function getWeatherData() {
  getWeatherDataCallback()
}

getWeatherData()