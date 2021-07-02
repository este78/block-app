//commmand line gets balance from ganache address
var Web3 = require('web3')

//port ganache is connected to
var web_instance = new Web3("http://127.0.0.1:7545");

async function getbalance() {
    var wei = await web_instance.eth.getBalance("0x7134a1cCa554180b9fbdDaB7816FB034A6e93FF6")
    var ether = web_instance.utils.fromWei(wei, 'ether')
    console.log(ether)
    console.log(wei)
    console.log(web_instance.utils.toWei(ether))
}

getbalance()