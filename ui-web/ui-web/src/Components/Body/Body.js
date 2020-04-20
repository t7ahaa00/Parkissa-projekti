import React, { Component } from 'react';
import MapWindow from '../MapWindow/MapWindow'
import classes from './Body.module.css';
import Aux from '../../hoc/Auxiliary/Auxiliary';
import SearchBar from '../SearchBar/Searchbar';

class Body extends Component {
	render() {
		return(
		<Aux>
			<div className={classes.Map}>
				<MapWindow 	
				/>
			</div>
			<div className={classes.SearchBar}>
				<SearchBar />
			</div>
		</Aux>	
		);
	}
};

export default Body;