import React, { Component } from "react";
import RugbyDAUMarketContract from "./contracts/RugbyDAUMarket.json";
import RugbyDAUTokenContract from "./contracts/RugbyDAUToken.json";
import getWeb3 from "./getWeb3";
import {StyledDropZone} from 'react-drop-zone';
import {FileIcon, defaultStyles} from 'react-file-icon';
import "react-drop-zone/dist/styles.css";
//import "bootstrap/dist/css/bootstrap";
import fileReaderPullStream from 'pull-file-reader';
import ipfs from './ipfs';
import Moment  from 'react-moment';
import {Route,Link} from 'react-router-dom';
import { Table, Button } from 'reactstrap';

import "./App.css";
import axios from 'axios';
import UserPage from "./components/UserPage";
import Market from "./components/Market";
import Creator from "./components/Creator";
import Home from "./components/Home";
import NavBar from "./components/NavBar";
import InputForm from "./components/InputForm";

class App extends Component {
  state = { nfts: [], web3: null, accounts: null, marketContract: null, tokenContract:null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = RugbyDAUMarketContract.networks[networkId];
      const market= new web3.eth.Contract(
        RugbyDAUMarketContract.abi,
        deployedNetwork && deployedNetwork.address,
      );
      const deployedNetwork2 = RugbyDAUTokenContract.networks[networkId];
      const token = new web3.eth.Contract(
        RugbyDAUTokenContract.abi,
        deployedNetwork2 && deployedNetwork2.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, marketContract: market, tokenContract:token });
      

    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };
  //what happens when creating a new nft
  onDrop = async(file) =>{
    try {
      //gets these vars from the state, see above
      const {tokenContract,marketContract, accounts} = this.state;
      //reads the file dropped
      const stream = fileReaderPullStream(file);
      const result = await ipfs.add(stream)
      console.log(result)
      console.log(result[0])
      //mint a token from the ipfs upload
      let minted = await tokenContract.methods.createToken(result[0].hash).send({from: accounts[0], gas: 300000});
      //once we it is minted we want to create an entry in the shop, price is hard coded, there is a fee for listing the token
      await marketContract.methods.createMerchandise(tokenContract, minted, 0.001).send({from: accounts[0],value: 1000000000000000, gas: 300000});
    } catch (error) {
      console.log(error);
    }
  };
  //Gives minter privileges to target account
  setMinter = async(address) =>{
    try{
        const {contract,accounts} = this.state;
        await tokenContract.methods.setMinter(address).send({from:accounts[0],gas:30000});
    }catch(error){
      console.log(error);
    }
  };
 
  
  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <NavBar />
        <Route exact path="/" component={Home} />
        <Route exact path="/creator" component={Creator} />
        <Route exact path="/market" component={Market} />
        <Route exact path="/userpage" component={UserPage} />
        <div className= "container pt-3">
          <StyledDropZone onDrop={this.onDrop} />
          <InputForm setMinter={this.setMinter}/>
          {this.state.nfts !== [] ? this.state.nfts.map((item,key) =>(
              <h1>{item}</h1>
          )):null}
           
       </div>
      </div>
    );
  }
}

export default App;
