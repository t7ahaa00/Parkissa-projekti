import React, { Component } from 'react';
import MapWindow from '../MapWindow/MapWindow'
import classes from './Body.module.css';

class Body extends Component {
	render() {
		return(
		<div className={classes.Body}>
			<MapWindow 	
			/>
		</div>
		);
	}
};

export default Body;