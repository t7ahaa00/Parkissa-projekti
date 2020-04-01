import React, { Component } from 'react';
//import ReactDOM from 'react-dom';
import { Map, GoogleApiWrapper, Marker, Polygon, InfoWindow} from 'google-maps-react';

import classes from './MapWindow.module.css';
import ParkDetailOverlay from '../ParkingDetails/ParkDetailOverlay/ParkDetailOverlay';

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
        }
    }

    onMarkerClick = (props, marker, e) =>
    this.setState({
      selectedPlace: props,
      activeMarker: marker,
      showingInfoWindow: true
    });

    onMapClicked = (props) => {
        if (this.state.showingInfoWindow) {
        this.setState({
            showingInfoWindow: false,
            activeMarker: null
        })
        }
    };

    // onInfoWindowOpen(props, e) {
    //     const button = (<button onClick={e => {console.log("hmapbuttoni1");}}>mapbutton</button>);
    //     ReactDOM.render(React.Children.only(button), document.getElementById("iwc"));
    //   }
    // Parking place sites marker placement
    displaySites = () => {
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
      
    render() {
         //Parking place coordinates   
        const polygonCoords = [
            {lat: 65.060014, lng: 25.470085},
            {lat: 65.060014, lng: 25.471944},
            {lat: 65.058479, lng: 25.471944},
            {lat: 65.058479, lng: 25.470085}
            ];

        const polygonCoordsA = [

            {lat: 65.061677, lng: 25.462875},
            {lat: 65.061677, lng: 25.464629},
            {lat: 65.060503, lng: 25.464629},
            {lat: 65.060503, lng: 25.462875}
            ];

        const polygonCoordsB = [

            {lat: 65.058841,  lng: 25.461625},
            {lat: 65.058841, lng: 25.462808},
            {lat: 65.057642,  lng: 25.462808},
            {lat: 65.057642, lng: 25.461625}
        ];

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
                <Polygon //Parking place drawing
                    paths={polygonCoords}
                    strokeColor="#0000FF"
                    strokeOpacity={0.8}
                    strokeWeight={2}
                    fillColor="#959595"
                    fillOpacity={0.70} />
                <Polygon 
                    paths={polygonCoordsA}
                    strokeColor="#00FF00"
                    strokeOpacity={0.8}
                    strokeWeight={2}
                    fillColor="#959595"
                    fillOpacity={0.70}
                />
                <Polygon 

                    paths={polygonCoordsB}
                    strokeColor="#FF0000"
                    strokeOpacity={0.8}
                    strokeWeight={2}
                    fillColor="#959595"
                    fillOpacity={0.70}
                />            
                {this.displaySites()} 
                <InfoWindow
                    marker={this.state.activeMarker}
                    visible={this.state.showingInfoWindow}>
                    <div>
                        <h2>{this.state.selectedPlace.name}</h2>
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

    // onOpen={e => {
                //     this.onInfoWindowOpen(this.props, e);
                //   }}
                // >
                //   <div id="iwc" />
                //     