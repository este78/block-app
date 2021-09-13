import React, { Component } from "react";
import RugbyDAUMarketContract from "./contracts/RugbyDAUMarket.json";
import RugbyDAUTokenContract from "./contracts/RugbyDAUToken.json";
import getWeb3 from "./getWeb3";
import {Route,Link} from 'react-router-dom'
import "./App.css";
import UserPage from "./components/UserPage";
import Market from "./components/Market";
import Creator from "./components/Creator";
import Home from "./components/Home";
import NavBar from "./components/NavBar";

class App extends Component {
  state = { nft: [], web3: null, accounts: null, contractMrkt: null, contractTkn:null };

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
      const token = new web3.eth.Contract(
        RugbyDAUTokenContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contractMrkt: market, contractTkn:token });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  getNFTs = async () => {
    const { contractMrkt, contractTkn } = this.state;

    // Get the vNFTs Listed in the Marketplace.
    const data = await contractMrkt.methods.showMarketStock();
    const items = await Promise.all(data.map(async i =>{
      const tokenUri = await contractTkn.tokenURI(i.tokenId)
      const metada = await ipfs.get(tokenUri)

    }))
    // Update state with the result.
    this.setState({ nft : [] });
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
      </div>
    );
  }
}

export default App;
