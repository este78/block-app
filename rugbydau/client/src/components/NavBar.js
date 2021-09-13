import React from 'react'
import {Link} from 'react-router-dom'

function NavBar() {
    return (
        <div>
            <ul>
                <li><Link to="/">Home</Link></li>
                <li><Link to="/creator">Creator</Link></li>
                <li><Link to="/market">Market</Link></li>
                <li><Link to="/userPage">User Page</Link></li>
            </ul>            
        </div>
    )
}

export default NavBar
