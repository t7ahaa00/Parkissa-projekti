import React, { Component } from 'react';
//import { Map, GoogleApiWrapper, Marker, Polygon, Circle, InfoWindow} from 'google-maps-react';
import classes from './MapWindow.module.css';
//import ParkDetailOverlay from './ParkDetailOverlay/ParkDetailOverlay';
import ParkJson from '../../assets/parkkipaikkadatatest.json';
//import axios from 'axios';
import Aux from '../../hoc/Auxiliary/Auxiliary';
import Spinner from '../../Components/Spinner/Spinner';
import GoogleMapReact from 'google-map-react';

const handleApiLoaded = (map, maps) => {
    // use map and maps objects
    ParkJson.parkingareas.map((parkAreas, index) => {
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

    ParkJson.parkingareas.map((parkAreas, index) => {
        console.log('[ParkAreas] ' + JSON.stringify(parkAreas.path))
        return parkAreas.slots.map((parkingSlots, index) => {

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
  };

class Search extends React.Component {
    
    constructor(props) {
        super(props);

        this.state={
            position: {}
        }
    }
    render() {
        return(
            <input type="text" name="search" placeholder="Search..">
                
            </input>
        )
        
    }
}



class MapWindow extends Component {

    constructor(props) {
        super(props);

        this.state= {
            showingInfoWindow: false,
            selectedPlace: {},
            position: {},
            loadingReady : true, 
            serverTestParkData: null
        }
    }
    
    componentDidMount() {

            //axios.get('https://react-jburger.firebaseio.com/parkdata.json')
           /*  axios.get('https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/testdata/parkinglot', {
                headers: {"x-api-key": process.env.REACT_APP_DATABASE_API_KEY},
                crossDomain: true,
                responseType:"json"})
            .then(response => {
                console.log('[ComponenDidMount] ' + JSON.stringify(response.data));
                this.setState({serverTestParkData: response.data})
                this.setState({loadingReady: true})
            }
            )
            .catch( error => {
                console.log( error );
            }); */
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
    /* displaySiteMarkers = () => {
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
    } */
    // Display all the polygons in JSON file
    displaySitePolygon = (map, maps) => {
        //return ParkJson.map((parkinglots, index) => {
        //return this.state.serverTestParkData.map((parkinglots, index) => {
            //console.log('[Polygon parkinglot' + JSON.stringify(parkinglots) );
            return ParkJson.parkingareas.map((parkAreas, index) => {
                console.log('[ParkAreas] ' + JSON.stringify(parkAreas.path))
                
                return(
                    
                    new maps.Polygon({
                        paths: parkAreas.path,
                        strokeColor: '#FF0000',
                        strokeWeight: 2,
                        fillColor: '#FF0000'
                    })
                )
            })
    }

    /*displaySearchBox = (map, maps) => {
        return(
            <SearchBox></SearchBox>
            //<input type="text" name="search" placeholder="Search.."></input>;
        )
    }*/

    displayParkingSlots = () => {
        return ParkJson.parkingareas.map((parkinglots, i) => {
            return parkinglots.slots.map((parkingSlots, i) => {
                const rad = 2;
                let circle = new this.props.google.maps.Circle({

                    center: parkingSlots.center,
                    radius: rad
                })

                return (
                    
                        {circle}
                    
                   

                    )}

                    
                )
            })

    }

    /* displayParkingSlots = () => {
        //return ParkJson.map((parkinglots, i) => {
        return this.state.serverTestParkData.map((parkinglots, i) => {
            return parkinglots.parkingareas.map((parkingarea, j) => {
                //console.log('[parkingarea]' + JSON.stringify(parkingarea))
                let table = []
                let tableOccupied = []
                
                // If-lausekkeella vältetään undefined error niiltä parkkialueilta joissa ei ole koordinaatteja määritelty
                if(parkingarea.path.length !== 0) {
                    var horizontalLength = parkingarea.path[0].lng - parkingarea.path[1].lng
                    var verticalLength = parkingarea.path[0].lat - parkingarea.path[2].lat

                    var lat1 = parkingarea.path[0].lat
                    var lat2 = parkingarea.path[2].lat
                    var lng1 = parkingarea.path[0].lng
                    var lng2 = parkingarea.path[1].lng

                    var rows = parkingarea.slots.length
                    var slots = parkingarea.avaiblespace
                    var slotsPerRow = slots / rows

                    console.log(horizontalLength)
                    console.log(verticalLength)

                    var plusToNextLng = horizontalLength / slotsPerRow
                    var plusToNextLat = verticalLength / rows

                    for (let i = 0; i < rows; i++) {
                        for (let j = 0; j < slotsPerRow; j++) {
                            
                            //ROWS == e.g 1 slots object in parkkialuedata.json
                            //SLOTSPERROW == e.g first row object in parkkialuedata.json

                            var isOccupied = parkingarea.slots[i].row[j].occupied

                            //console.log("TAMA ON isOccupied ARVO = " + isOccupied)


                            var pathForSlot = [
                                {
                                    lat: lat1,
                                    lng: lng1
                                },
                                {
                                    lat: lat1,
                                    lng: lng2
                                },
                                {
                                    lat: lat2,
                                    lng: lng2
                                },
                                {
                                    lat: lat2,
                                    lng: lng1
                                }
                            ]
                            
                            table.push(pathForSlot)
                            tableOccupied.push(isOccupied)

                            lng1 = lng1 - plusToNextLng
                            //console.log(lng1)
                            //console.log(isOccupied)
                        }


                        //SELVITÄ MITEN SAADAAN AJOVAYLAT PARKKIPAIKKOJEN VALIIN

                        lat1 = lat1 - plusToNextLat
                        lng1 = parkingarea.path[0].lng
                        //console.log(lat1)
                    }
                }
*/
                //return table

                /*

                     SLOTS PER ROW (horizontal)

                R    '''''''''' 
                O    ''''''''''
                W    ''''''''''
                S    ''''''''''

                */
/*
                return table.map((path, index) => {
                    
                    var green = '#7CFC00'
                    var red = '#DC143C'
                    var color = ''
                    var checkable = tableOccupied[index]
                    if (checkable === 1) {
                        color = red
                    } else {
                        color = green
                    }

                    //console.log(tableOccupied[index].isOccupied + " " + color)
                    //console.log(checkable + " " + color)
                    
                    return(
                    <Polygon 
                    key={index}
                    paths={path}
                    fillOpacity={1}
                    strokeWeight={1}
                    fillColor={color} >
                     </Polygon>
                    )
                })
            })
        })
    } */

    // for testing purposes
    /* clickedPolygon = (props) =>{
        console.log("Polygon clicked ", props.name );
    } */

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

    createSearchBoxOptions = (maps) => {
        return{
            searchBoxOptions: {
                position: maps.ControlPosition.LEFT_TOP
            }
        };
    }
    
    render() {
        // Loading wheel showed while loading data
        let displayPolygons = this.state.loadingReady ? <p>Loading...</p> : <Spinner />;
        //console.log(process.env);

        // Map displays when data from server has been loaded
        if (ParkJson !== null) {
            
            displayPolygons = (
                <div style={{ height: '90vh', width: '100%', zIndex: 1, position: "absolute", top: 0, bottom: 0 }}>
                
                <GoogleMapReact
                    bootstrapURLKeys={{ key: process.env.REACT_APP_GOOGLE_API_KEY }}
                    defaultCenter={{ lat: 65.0595, lng: 25.4662}}
                    defaultZoom={16}
                    /* mapTypeControlOptions={{position: this.props.google.maps.ControlPosition.LEFT_BOTTOM}} */
                    onClick={this.onMapClicked}
                    yesIWantToUseGoogleMapApiInternals
                    onGoogleApiLoaded={({ map, maps }) => handleApiLoaded(map, maps)}
                    options={this.createMapOptions}
                    >
                    {this.displaySearchBox}
                    {/* {this.displaySitePolygon()}
                    {this.displayParkingSlots()}  */}
                     
                    {/* <InfoWindow
                        position={this.state.position}
                        visible={this.state.showingInfoWindow}
                        name={this.state.selectedPlace.name} >
                            <div>
                                <h3>{this.state.selectedPlace.name}</h3>
                                <ParkDetailOverlay />
                            </div>         
                    </InfoWindow> */}
                </GoogleMapReact>
                <div style={{ height: '90vh', width: '100%', zIndex: 2, position: "absolute", top: 0, bottom: 0 }}>
                    <Search></Search>
                </div>
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

/* GoogleApiWrapper({
    apiKey: process.env.REACT_APP_GOOGLE_API_KEY
    })(MapWindow);   */
