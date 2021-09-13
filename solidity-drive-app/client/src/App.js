import React, { Component } from "react";
import RugbyDAUTokenContract from "./contracts/RugbyDAUToken.json";
import getWeb3 from "./getWeb3";
import { StyledDropZone } from 'react-drop-zone';
import { FileIcon, defaultStyles } from 'react-file-icon';
import "react-drop-zone/dist/styles.css";
import "bootstrap/dist/css/bootstrap.css";
import { Table, Button } from 'reactstrap';
import fileReaderPullStream from 'pull-file-reader';
import ipfs from './ipfs';
import Moment  from 'react-moment';
import InputForm from "./components/MinterForm";
import TransferForm from "./components/TransferForm";
import "./App.css";
import CommonAreaForm from "./components/CommonAreaForm";

class App extends Component {

  constructor(){
    super();
    this.state = { nftDrive: [], web3: null, accounts: null, contract: null };
  }
  
  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = RugbyDAUTokenContract.networks[networkId];
      const instance = new web3.eth.Contract(
        RugbyDAUTokenContract.abi, 
        deployedNetwork && deployedNetwork.address);

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.getFile);
      
      //automatically refresh the list when changing accounts
      web3.currentProvider.on('accountsChanged', async () => {
        const changedAccounts = await web3.eth.getAccounts();
        //update the state and get the files from the new account for rendering
        this.setState({accounts: changedAccounts});
        this.getFile();
      })
    
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
      
    }
  };

  getFile = async() =>{
    //any await must be wrapped in a try/catch
    try {
      //gets these vars from the state, see above
      const {accounts, contract} = this.state;
      //in order to loop through the chain data we need the length of the array for each mapping entry, see the nftDrive contract.
      let filesLength = await contract.methods.getLength().call({from: accounts[0]});
      //create an array where to store the data from the contract
      let files = []
      //loop through the data in the chain linked to the sender account (account 0)
      for (let i = 0; i < filesLength; i++) {
          //get the file from the chain
          let file = await contract.methods.getFile(i).call({from: accounts[0]});
          //push the data to our array in js
          //if(file.hash != ""){
            files.push(file);
          //}
      }
      //set the data as the state of the application
      this.setState({ nftDrive: files });  
    } catch (error) {
      console.log(error);
    }  
  };

  onDrop = async(file) =>{
    try {
      //gets these vars from the state, see above
      const {contract, accounts} = this.state;
      //ipfs upload and read, other metadata is derived
      const stream = fileReaderPullStream(file);
      const result = await ipfs.add(stream);
      const timestamp = Math.round(+new Date() / 1000);
      const type = file.name.substr(file.name.lastIndexOf(".")+1);
      //new nft is minted
      let uploaded = await contract.methods.add(result[0].hash, file.name, type, timestamp).send({from: accounts[0], gas: 600000});
      
      console.log(uploaded);
      //once we dropped the new file we want to call all the uploaded files by calling getFiles()
      this.getFile();

    } catch (error) {
      console.log(error);
    }
  };
  //set minter permissions, only owner function
  setMinter = async(address) =>{
    try{
        const {contract,accounts} = this.state;
        await contract.methods.setMinter(address).send({from:accounts[0],gas:300000});
        let isMinter = await contract.methods.isMinter(address).send({from:accounts[0],gas:300000})
        console.log(isMinter)
    }catch(error){
      console.log(error);
    }
  };
  //transferrring a nft owned by sender to another user provider
  transferFile = async(i,val) =>{
    const {nftDrive,contract, accounts} =this.state;
    if(nftDrive!==[]){
        try{
          let tokenID = nftDrive[i].id;
          (console.log(tokenID));
          await contract.methods.transferRGBY(i,tokenID,val).send({from:accounts[0],gas:600000});
        }catch(error){
          console.log(error);
        }
      }else{
        alert("The Drive is empty, nothing to transfer");
      }
  };
  //WORK IN PROGRESS. It needs to go in a different page
  showCommonArea = async()=>{
    //any await must be wrapped in a try/catch
    try {
      //gets these vars from the state, see above
      const {accounts, contract} = this.state;
      //in order to loop through the chain data we need the length of the array for each mapping entry, see the nftDrive contract.
      let filesLength = await contract.methods.getMarketLength().call({from: accounts[0]});
      //create an array where to store the data from the contract
      let files = []
      //loop through the data in the chain linked to the sender account (account 0)
      for (let i = 0; i < filesLength; i++) {
          //get the file from the chain
          let file = await contract.methods.getMarketFile(i).call({from: accounts[0]});
          //push the data to our array in js
          //if(file.hash != ""){
            files.push(file);
          //}
      }
      //set the data as the state of the application
      this.setState({ nftDrive: files });  
    } catch (error) {
      console.log(error);
    }
  }

  render() {
    const {nftDrive} = this.state;
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
     <div className= "App" >
       <div className= "container pt-3">
         <h1>RUGBYDAU NFT-EXCHANGE</h1>
         <br />
          <StyledDropZone onDrop={this.onDrop}>Create a NFT By Dropping A File Here </StyledDropZone>
          <br/>
          <TransferForm transferFile={this.transferFile}></TransferForm>
          <br/>
          <CommonAreaForm showCommonArea={this.showCommonArea} ></CommonAreaForm>
          <Table>
              <thead>
                <tr>
                  <th className="text-left">Token ID</th>
                  <th width="5%" scope="row">Type</th>
                  <th className="text-left">File Name</th>
                  <th className="text-right">Date</th>
                  <th>Index</th>
                </tr>
              </thead>
              <tbody>
                {nftDrive !== [] ? nftDrive.map((item, key) =>(
                  <tr>
                    <th>{item[0]}</th>
                    <th><FileIcon size="30" extension={item[3]} {...defaultStyles[item[3]]}></FileIcon></th>
                    <th className="text-left"><a href={"https://ipfs.io/ipfs/"+item[1]} >{item[2]}</a></th>
                    <th className="text-right"><Moment format="YYYY/MM/DD" unix>{item[4]}</Moment></th>
                    <th><Button>{key}</Button></th>
                </tr>
                 )): null}
                
              </tbody>
          </Table> 
          <InputForm setMinter={this.setMinter}/>
          <br/> 
       </div>
     </div>
    );
  }
};

export default App;