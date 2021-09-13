import React,{Component} from 'react'

//shows the contract owners nftDrive to anyone who wants to see. The idea is that the marketplace could start here
class CommonAreaForm extends Component{
    constructor(props){
        super(props);
        this.state={
        }
    } 
    handleSubmit = ()=>{
        this.props.showCommonArea();
    }
    render(){
        return (
        <form onSubmit={this.handleSubmit}>
            <label>Show Common Area Files&nbsp; (WIP)</label>
            <button type="submit">Go</button>
        </form>)
    }
}

export default CommonAreaForm