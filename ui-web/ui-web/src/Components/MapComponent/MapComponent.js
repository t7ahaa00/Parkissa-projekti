import React, { Component } from 'react';
import { Map, GoogleApiWrapper, Marker } from 'google-maps-react';

import classes from './MapComponent.module.css';

class MapComponent extends Component {

    state= {
        parkSites: [
            {lat: 65.0594, lng: 25.4711},
            {lat: 65.061, lng: 25.4638},
            {lat: 65.0582, lng: 25.4622},
        ]
    }

    displaySites = () => {
        return this.state.parkSites.map((parkSite, index) => {
            return <Marker key={index} id={index} position={{
                lat: parkSite.lat,
                lng: parkSite.lng
            }} />
        })
    }

    render() {

        return (
            <Map
          google={this.props.google}
          zoom={16}
          className={classes.Map}
          initialCenter={{ lat: 65.0595, lng: 25.4662}}
        >
            {this.displaySites()}
        </Map>
        );
    }
};

export default GoogleApiWrapper({
    apiKey: 'AIzaSyD38KVBa8COxekeVYZz9ypRqwUGKuJQkrM'
})(MapComponent);