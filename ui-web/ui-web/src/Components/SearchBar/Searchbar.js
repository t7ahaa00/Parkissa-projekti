import React from 'react';

//import classes from './SearchBar.module.css';

class Search extends React.Component {
    
    constructor(props) {
        super(props);

        this.state={
            position: {}
        }
    }
    render() {
        return(
            <input type="text" name="search" placeholder="Search..">
                
            </input>
        )
        
    }
}
export default Search;