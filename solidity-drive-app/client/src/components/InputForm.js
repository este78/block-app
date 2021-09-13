import React,{Component} from 'react'


class InputForm extends Component{
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
                <label>Add Creator</label>
                <input type="text" required value={this.address} 
                onChange={(e)=>this.setState({address: e.target.value})} />
                <button type="submit">Submit</button>
        </form>)
    }
}

export default InputForm