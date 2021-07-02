//transfers ETH from one address to another

var Tx = require("ethereumjs-tx").Transaction
var Web3 = require("web3")
var web3_instance = new Web3("http://127.0.0.1:7545");

async function sendEth(here) {
    try {
        var amount = '5'
        var gasFees = '1'
        var gasLimit = '300000'
        var toAddress = here.String()
    
        var privateKey = Buffer.from('b2f7098f6678b19a811704f31f549b916913df1fb403cd497bb8ccacc1639edd', "hex")
        var rawTransaction = {
            nonce: await web3_instance.eth.getTransactionCount("0x7134a1cCa554180b9fbdDaB7816FB034A6e93FF6"),
            gasPrice: web3_instance.utils.numberToHex(gasFees),
            gasLimit: web3_instance.utils.numberToHex(gasLimit),
            to: toAddress,
            value: web3_instance.utils.numberToHex(web3_instance.utils.toWei(amount, 'ether'))
        }
    
        var transaction = await new Tx(rawTransaction)
        await transaction.sign(privateKey)
        
        var serialisedTransaction = transaction.serialize()
        console.log(await web3_instance.eth.sendSignedTransaction('0x' + serialisedTransaction.toString("hex")))

        console.log(await web3_instance.eth.getAccounts())

    } catch(e) {
        console.log(e)
    }
}




sendEth()