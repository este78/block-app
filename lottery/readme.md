Author : Esteban Araújo-Fervenza, x20170416. NCI

# Dependencies
npm, nodemon, web3, truffle-contract, ethereumjs-tx, truffle, ganache, metamask wallet

# Install dependencies
On the command line interface, navigate to the folder called "lottery"

1-install npm by typing 'npm install' and hitting enter.
2-install nodemon by typing 'npm install nodemon' and hitting enter.
3-install truffle by typing 'npm install truffle -g' and hitting enter.
4-install npm by typing 'npm install web3' and hitting enter.
5-install npm by typing 'npm install truffle-contract' and hitting enter.
6-install npm by typing 'npm install ethereumjs-tx' and hitting enter.

Download the Ganache app from https://www.trufflesuite.com/ganache
Download a metamask plug-in for your browser.

# Instructions

Open the Ganache app:
The ganache mnemonic: 
science tourist monster cat bubble hero until flush hedgehog near script flash

The first account, account[0] is the one that is linked to the ownership of the contract.
Open metamaskin your browser and import one of the ganache accounts. In metamask use the network: localhost:7545 and import the account by copy and pasting the secret key found in the ganache's GUI

On the command line interface, navigate to the folder called "lottery"
1-Initiate the localhost by typing 'npm run dev'.

On a new command line, navigate to the 'lottery' folder and migrate the contracts
2- type 'truffle migrate'

Open a browser and in the url type 'localhost:3000'
The page will automatically try to connect to the wallet.

To use the app simply click on draw number.