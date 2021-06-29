var Web3 = require('web3')

var web_instance = new Web3("http://127.0.0.1:7545");

async function getbalance() {
    var wei = await web_instance.eth.getBalance("0xB3f8c6274EcF67bBB1251A79Bf5a6351e36C01D1")
    var ether = web_instance.utils.fromWei(wei, 'ether')
    console.log(ether)
    console.log(wei)
    console.log(web_instance.utils.toWei(ether))
}

getbalance()
