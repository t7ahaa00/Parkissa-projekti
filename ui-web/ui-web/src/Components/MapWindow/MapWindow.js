import React, { Component } from 'react';
import { Map, GoogleApiWrapper, Marker, Polygon, InfoWindow} from 'google-maps-react';

import classes from './MapWindow.module.css';
import ParkDetailOverlay from './ParkDetailOverlay/ParkDetailOverlay';
import ParkJson from '../../assets/parkkialuedata.json';

class MapWindow extends Component {

    constructor(props) {
        super(props);

        this.state= {
            showingInfoWindow: false,
            selectedPlace: {},
            position: {},
        }
    }

    // Show infowindow when clicking polygon
    onPolyClick = (props, e) =>
    this.setState({
      selectedPlace: props,
      position: props.position,
      showingInfoWindow: true
    });
    // Hide infowindow when clicking on the map
    onMapClicked = (props) => {
        if (this.state.showingInfoWindow) {
        this.setState({
            showingInfoWindow: false,
            activeMarker: null
        })
        }
    };

    // Parking place sites marker placement
    displaySiteMarkers = () => {
        return this.state.parkSites.map((parkSite, index) => {
            return <Marker key={index} id={index} position={{
                lat: parkSite.lat,
                lng: parkSite.lng
                }}
                onClick={this.onMarkerClick}
                name={parkSite.name}
                 ><div>
                     Moro<img src={require('../../assets/alien.png')} alt="Alien"></img>
                 </div>
                 </Marker>
        })
    }
    // Display all the polygons in JSON file
    displaySitePolygon = () => {
        return ParkJson.map((parkinglots, index) => {
            console.log(Object(parkinglots) );
            return parkinglots.parkingareas.map((parkAreas, index) => {
                return(
                <Polygon 
                key={index} 
                id={parkAreas.id} 
                paths={parkAreas.path}
                onClick={this.onPolyClick}
                name={parkinglots.name + ' ' + parkAreas.id}
                position={parkAreas.path[0]}
                 >{/* <div>
                     Moro<img src={require('../../assets/alien.png')} alt="Alien"></img>
                 </div> */}
                 </Polygon>
                )
            })   
        })
    }
    // for testing purposes
    clickedPolygon = (props) =>{
        console.log("Polygon clicked ", props.name );
    }

    render() {
        return(
            <Map
                google={this.props.google}
                zoom={16}
                className={classes.Map}
                initialCenter={{ lat: 65.0595, lng: 25.4662}}
                mapTypeControl={true}
                zoomControl={true}
                mapTypeControlOptions={{position: this.props.google.maps.ControlPosition.LEFT_BOTTOM}}
                streetViewControl={false}
                onClick={this.onMapClicked}
                >          
                
                {this.displaySitePolygon()}

                <InfoWindow
                    position={this.state.position}
                    visible={this.state.showingInfoWindow}
                    name={this.state.selectedPlace.name} >
                        <div>
                            <h3>{this.state.selectedPlace.name}</h3>
                            <ParkDetailOverlay />
                        </div>
                        
                </InfoWindow>
            </Map>
        );
    }
};

export default GoogleApiWrapper({
    apiKey: 'AIzaSyD38KVBa8COxekeVYZz9ypRqwUGKuJQkrM'
    })(MapWindow);  
