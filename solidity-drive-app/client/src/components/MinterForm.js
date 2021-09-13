import React,{Component} from 'react'

//sends values to the app.js to be used as args in setMinter function
class MinterForm extends Component{
    constructor(props){
        super(props);
        this.state={
            address:''
        }
    }

    handleSubmit = (e)=>{
        (e).preventDefault();
        let val = this.state.address;
        this.props.setMinter(val);
    }
    render(){
        return (
            <form onSubmit={this.handleSubmit}>
                <br />
                <h5>Add Minter</h5>
                <p> If a non authorised user tries to add a minter, it won't work and they will be charged</p>
                <label>Admin only:&nbsp;</label>
                <input type="text" required value={this.address} placeholder="enter minter's address" onChange={(e)=>this.setState({address: e.target.value})} />
                <button type="submit">Submit</button>
        </form>)
    }
}

export default MinterForm