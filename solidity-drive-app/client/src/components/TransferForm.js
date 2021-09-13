import React,{Component} from 'react'

//sends values to be used in the transferring of files between drives
class TransferForm extends Component{
    constructor(props){
        super(props);
        this.state={
            index: null,
            address:''
        }
    }
    handleSubmit = (e)=>{
        (e).preventDefault();
        let i = this.state.index;
        let val = this.state.address;
        this.props.transferFile(i,val);
    }
    render(){
        return (
        <form onSubmit={this.handleSubmit}>
            <h4>Transfer Your NFT</h4>
            <label>Input File Index:&nbsp;</label>
            <input type="number" required value={this.index} 
                   onChange={(e)=>this.setState({index: e.target.value})} />
            <label>&nbsp;&nbsp;Recipient's Address:&nbsp;</label>
            <input type="text" required value={this.address} 
                   onChange={(ev)=>this.setState({address: ev.target.value})} />
            <button type="submit">Transfer</button>
        </form>)
    }
}

export default TransferForm