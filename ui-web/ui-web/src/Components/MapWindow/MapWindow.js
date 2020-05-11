import React, { Component } from 'react';
//import ParkJson from '../../assets/parkkipaikkadatatest.json';
import axios from 'axios';
import Aux from '../../hoc/Auxiliary/Auxiliary';
import Spinner from '../../Components/Spinner/Spinner';
import GoogleMapReact from 'google-map-react';


const handleApiLoaded = (map, maps, serverTestParkData) => {
    // use map and maps objects
    serverTestParkData.map((serverData, index) => {
        return(
            serverData.parkingareas.map((parkAreas, index) => {
                console.log('[ParkAreas] ' + JSON.stringify(parkAreas.path))
                return(
                    new maps.Polygon({
                        strokeColor: '#FF0000',
                        strokeOpacity: 0.8,
                        strokeWeight: 2,
                        fillColor: '#888888',
                        fillOpacity: 0.1,
                        map,
                        path: parkAreas.path,
                    })
                )
            })
        )
    })

    serverTestParkData.map((serverData, index) => {
        return(
            serverData.parkingareas.map((parkAreas, index) => {
                
                return parkAreas.slots.map((parkingSlots, index) => {
                    console.log('[ParkingSlots] ' + JSON.stringify(parkingSlots))
                    var green = '#7CFC00'
                    var red = '#DC143C'
                    var color = ''
                    var checkable = parkingSlots.occupied
                    if (checkable === 1) {
                        color = red
                    } else {
                        color = green
                    }
                    return(
                        new maps.Circle({
                            strokeColor: color,
                            strokeOpacity: 1,
                            strokeWeight: 1,
                            fillColor: color,
                            fillOpacity: 1,
                            map,
                            center: parkingSlots.center,
                            radius: 1
                        })
                    )
                })
            })
        )
        })
  };
  

class MapWindow extends Component {

    

    createMapOptions = (maps) => {
        return {
            zoomControlOptions: {
                position: maps.ControlPosition.RIGHT_CENTER,
                style: maps.ZoomControlStyle.SMALL
              },
              mapTypeControlOptions: {
                position: maps.ControlPosition.LEFT_BOTTOM
              },
              mapTypeControl: true
            };
    }
    
    render() {
        // Loading wheel showed while loading data
        let displayPolygons = this.props.serverData !== null ? <p>Loading...</p> : <Spinner />;
        //console.log(process.env);

        // Map displays when data from server has been loaded
        if (this.props.serverData !== null) {
            
            displayPolygons = (
                <div style={{ height: '90vh', width: '100%', zIndex: 1, position: "absolute", top: 0, bottom: 0 }}>
                    <GoogleMapReact
                        bootstrapURLKeys={{ key: process.env.REACT_APP_GOOGLE_API_KEY }}
                        center={this.props.centerMap}
                        zoom={this.props.mapZoom}
                        onClick={this.onMapClicked}
                        yesIWantToUseGoogleMapApiInternals
                        onGoogleApiLoaded={({ map, maps }) => handleApiLoaded(map, maps, this.props.serverData)}
                        options={this.createMapOptions}>
                    </GoogleMapReact>
                </div>
            );
        }
            
        return(
            <Aux>
                {displayPolygons}
            </Aux>
        );
    }
};

export default MapWindow;