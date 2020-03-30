import React, { Component } from 'react';
import MapComponent from '../../MapComponent/MapComponent'
import classes from './Body.module.css';

class Body extends Component {
	render() {
		return(
		<div className={classes.Body}>
			<MapComponent 
				// id="myMap"
				// options={{
				// 	center: { lat: 65.0595, lng: 25.4662 },
				// 	zoom: 16,
				// 	mapTypeControl: true,
					
				// }}
				// onMapLoad={map => {
				// 	var marker = new window.google.maps.Marker({
				// 	position: { lat: 65.0594, lng: 25.4711 },
				// 	map: map,
				// 	title: 'Parkki!'
          		// 	});
        		// }}
			/>
		</div>
		);
	}

};

export default Body;