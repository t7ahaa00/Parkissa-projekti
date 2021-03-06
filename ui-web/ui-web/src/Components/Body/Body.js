import React, { Component } from 'react';
import MapWindow from '../MapWindow/MapWindow'
import classes from './Body.module.css';
import Aux from '../../hoc/Auxiliary/Auxiliary';
import SearchBar from '../SearchBar/Searchbar';
import axios from 'axios';
import AddParkingLot from '../AddParkingLot/AddParkingLot';

class Body extends Component {

	constructor(props) {
        super(props);

        this.state= {
			serverParkData: null,
			center: {
				lat: 65.0595, lng: 25.4662
			},
			zoom: 14,
			showDataAdder: false
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

	componentDidUpdate(prevProps, prevState) {
		if (prevState.center !== this.state.center) {
			console.log('center state has changed.')
		}
	}

	componentWillReceiveProps({someProp}) {
		this.setState({...this.state,someProp})
	  }

	handleToUpdate = (centerData) => {
		console.log(this.state.center)
		console.log(centerData);
		this.setState({center: centerData, zoom: 16});
	}

	showDataAdderHandler = () => {

		this.setState( (prevState) => {
			return {showDataAdder: !prevState.showDataAdder};
		}); 
	}
		
	render() {

		if (this.state.showDataAdder === false) { 
		return(
		<Aux>
			<div className={classes.Map}>
				<MapWindow 	serverData={this.state.serverParkData} centerMap={this.state.center} mapZoom={this.state.zoom}/>
			</div>
			<button className={classes.Button} onClick={this.showDataAdderHandler}>Datan syöttö</button>
			<div className={classes.SearchBar}>
				<SearchBar serverData={this.state.serverParkData} handleToUpdate={this.handleToUpdate}/>
				{console.log("rendering " + this.state.center.lat)}
			</div>
		</Aux>	
		);
	}
	else {
		return (
			<div>
				<button className={classes.Button} onClick={this.showDataAdderHandler}>Datan syöttö</button>
				<AddParkingLot />

			</div>
		)
	}
	}
};

export default Body;