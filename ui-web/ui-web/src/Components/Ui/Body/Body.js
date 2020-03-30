import React, { Component } from 'react';
import MapComponent from '../../MapComponent/MapComponent'
import classes from './Body.module.css';

class Body extends Component {
	render() {
		return(
		<div className={classes.Body}>
            <MapComponent />
        </div>
		);
	}

};

export default Body;