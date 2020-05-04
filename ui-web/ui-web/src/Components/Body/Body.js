import React, { Component } from 'react';
import MapWindow from '../MapWindow/MapWindow'
import classes from './Body.module.css';
import Aux from '../../hoc/Auxiliary/Auxiliary';
import SearchBar from '../SearchBar/Searchbar';
import axios from 'axios';

class Body extends Component {

	constructor(props) {
        super(props);

        this.state= {
			serverParkData: null,
		}
	}
	
	componentDidMount() {

          axios.get('https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/parkinglot', {
            headers: {"x-api-key": process.env.REACT_APP_DATABASE_API_KEY},
            crossDomain: true,
            responseType:"json"})
        .then(response => {
            console.log('[ComponenDidMount] ' + JSON.stringify(response.data));
            this.setState({serverParkData: response.data})
        }
        )
        .catch( error => {
            console.log( error );
		});  
	}
		
	render() {
		return(
		<Aux>
			<div className={classes.Map}>
				<MapWindow 	serverData={this.state.serverParkData}/>
			</div>
			<div className={classes.SearchBar}>
				<SearchBar serverData={this.state.serverParkData}/>
			</div>
		</Aux>	
		);
	}
};

export default Body;