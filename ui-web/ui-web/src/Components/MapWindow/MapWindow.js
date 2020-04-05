import React, { Component } from 'react';
import { Map, GoogleApiWrapper, Marker, Polygon, InfoWindow} from 'google-maps-react';

import classes from './MapWindow.module.css';
import ParkDetailOverlay from '../ParkingDetails/ParkDetailOverlay/ParkDetailOverlay';
import ParkJson from '../../assets/esimerkkiJSON.json';

class MapWindow extends Component {

    constructor(props) {
        super(props);

        this.state= {
            // Parking sites marker coordinates
            parkSites: [
                {lat: 65.0594, lng: 25.4711, name: 'Yliopisto1', img: <img src={require('../../assets/alien.png')} alt="Alien"></img>},
                {lat: 65.061, lng: 25.4638, name: 'Yliopisto2'},
                {lat: 65.0582, lng: 25.4622, name: 'Yliopisto3'},
            ],

            showingInfoWindow: false,
            activeMarker: {},
            selectedPlace: {},
            activePolycon: {},
            position: {},
        }
    }

    onMarkerClick = (props, marker, e) =>
    this.setState({
      selectedPlace: props,
      activeMarker: marker,
      showingInfoWindow: true
    });
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
        return ParkJson.parkkipaikat.map((coords, index) => {
            console.log(coords.parkkialueet[0].path)
            return coords.parkkialueet.map((parkCoords, index) => {
                return(
                <Polygon 
                key={index} 
                id={coords.parkkialueet[index].id} 
                paths={coords.parkkialueet[index].path}
                onClick={this.onPolyClick}
                name={coords.name + ' ' + coords.parkkialueet[index].id}
                position={coords.parkkialueet[index].path[0]}
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

                { <InfoWindow
                    position={this.state.position}
                    visible={this.state.showingInfoWindow}>
                    <div>
                        <h2>{this.state.selectedPlace.name}</h2>
                        <ParkDetailOverlay />
                    </div>
                </InfoWindow> }
            </Map>
        );
    }
};

export default GoogleApiWrapper({
    apiKey: 'AIzaSyD38KVBa8COxekeVYZz9ypRqwUGKuJQkrM'
    })(MapWindow);  
