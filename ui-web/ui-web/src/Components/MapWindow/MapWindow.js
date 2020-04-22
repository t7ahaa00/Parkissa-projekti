import React, { Component } from 'react';
//import { Map, GoogleApiWrapper, Marker, Polygon, Circle, InfoWindow} from 'google-maps-react';
//import classes from './MapWindow.module.css';
//import ParkDetailOverlay from './ParkDetailOverlay/ParkDetailOverlay';
//import ParkJson from '../../assets/parkkipaikkadatatest.json';
import axios from 'axios';
import Aux from '../../hoc/Auxiliary/Auxiliary';
import Spinner from '../../Components/Spinner/Spinner';
import GoogleMapReact from 'google-map-react';

let ParkJson;

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
        axios.get('https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/parkinglot', {
            headers: {"x-api-key": process.env.REACT_APP_DATABASE_API_KEY},
            crossDomain: true,
            responseType:"json"})
        .then(response => {
            console.log('[ComponenDidMount] ' + JSON.stringify(response.data));
            //this.setState({serverTestParkData: response.data})
            this.setState({serverTestParkData: response.data})
            //this.setState({loadingReady: true})
            console.log(ParkJson)
        }
        )
        .catch( error => {
            console.log( error );
        });

        /*const createTestParkingArea = {
            "name": "testinimi3",
            "areaID": 1,
            "avaibleSlots": 20,
            "orientation": 90,
            "path": [
                {"lat":65.0590539874513,"lng":25.470136035638625},
                {"lat":65.0590573805843,"lng":25.471943844514662},
                {"lat":65.0584873281781,"lng":25.471949208932692},
                {"lat":65.0584839349725,"lng":25.47013335342961}
            ]
        }*/

        
        /*
        axios.post('https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/parkinglot', {
            data: (JSON.parse(createTestParkingArea)),
            headers: {"x-api-key": process.env.REACT_APP_DATABASE_API_KEY},
            crossDomain: true,
            responseType:"json",
            })
        .then(response => {
            console.log(response.data)
            this.setState({loadingReady: true})
        }).catch((error) => {
            console.log(error)
        })*/

        /////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////
        ///////////////           slotsObject is defined at the bottom            ///////////////
        /////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////

        /*axios.post('https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/parkinglot/{4}/grid/create', slotsObject {
            headers: {"x-api-key": process.env.REACT_APP_DATABASE_API_KEY},
            crossDomain: true,
            responseType:"json"})
        .then(response => {
            console.log(response.data)
        }).catch((error) => {
            console.log(error)
        });*/

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
    
    render() {
        // Loading wheel showed while loading data
        let displayPolygons = this.state.loadingReady ? <p>Loading...</p> : <Spinner />;
        //console.log(process.env);

        // Map displays when data from server has been loaded
        if (this.state.serverTestParkData !== null) {
            
            displayPolygons = (
                <div style={{ height: '90vh', width: '100%', zIndex: 1, position: "absolute", top: 0, bottom: 0 }}>
                    <GoogleMapReact
                        bootstrapURLKeys={{ key: process.env.REACT_APP_GOOGLE_API_KEY }}
                        defaultCenter={{ lat: 65.0595, lng: 25.4662}}
                        defaultZoom={16}
                        onClick={this.onMapClicked}
                        yesIWantToUseGoogleMapApiInternals
                        onGoogleApiLoaded={({ map, maps }) => handleApiLoaded(map, maps, this.state.serverTestParkData)}
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

const slotsObject = {
    "slots": [
        {"slot":1,"center":{"lat":65.0589675264858,"lng":25.470319656421523},"occupied":1},
        {"slot":2,"center":{"lat":65.0589697885818,"lng":25.470370618392806},"occupied":1},
        {"slot":3,"center":{"lat":65.0589697885818,"lng":25.470429626991134},"occupied":1},
        {"slot":4,"center":{"lat":65.0589686575338,"lng":25.470480588962417},"occupied":1},
        {"slot":5,"center":{"lat":65.0589675264858,"lng":25.470534233142715},"occupied":1},
        {"slot":6,"center":{"lat":65.0589686575338,"lng":25.470585195113998},"occupied":1},
        {"slot":7,"center":{"lat":65.0589675264858,"lng":25.470644203712325},"occupied":1},
        {"slot":8,"center":{"lat":65.0589686575338,"lng":25.470697847892623},"occupied":1},
        {"slot":9,"center":{"lat":65.0589675264858,"lng":25.470748809863906},"occupied":1},
        {"slot":10,"center":{"lat":65.0589686575338,"lng":25.47080513625322},"occupied":1},
        {"slot":11,"center":{"lat":65.0589675264858,"lng":25.47086146264253},"occupied":1},
        {"slot":12,"center":{"lat":65.0589686575338,"lng":25.470907060195785},"occupied":1},
        {"slot":13,"center":{"lat":65.0589675264858,"lng":25.470960704376083},"occupied":1},
        {"slot":14,"center":{"lat":65.0589675264858,"lng":25.47101971297441},"occupied":0},
        {"slot":15,"center":{"lat":65.0589675264858,"lng":25.471073357154708},"occupied":1},
        {"slot":16,"center":{"lat":65.0589697885818,"lng":25.47111895470796},"occupied":1},
        {"slot":17,"center":{"lat":65.0589697885818,"lng":25.471169916679244},"occupied":1},
        {"slot":18,"center":{"lat":65.0589709196298,"lng":25.471231607486587},"occupied":1},
        {"slot":19,"center":{"lat":65.0589709196298,"lng":25.47128256945787},"occupied":0},
        {"slot":20,"center":{"lat":65.0589686575338,"lng":25.471336213638168},"occupied":1},
        {"slot":21,"center":{"lat":65.0589720506777,"lng":25.47138181119142},"occupied":0},
        {"slot":22,"center":{"lat":65.0589697885818,"lng":25.47144081978975},"occupied":0},
        {"slot":23,"center":{"lat":65.0589697885818,"lng":25.471483735133987},"occupied":0},
        {"slot":24,"center":{"lat":65.0589709196298,"lng":25.471542743732314},"occupied":1},
        {"slot":25,"center":{"lat":65.0589731817256,"lng":25.471596387912612},"occupied":1},
        {"slot":26,"center":{"lat":65.0589709196298,"lng":25.47165003209291},"occupied":0},
        {"slot":27,"center":{"lat":65.0589697885818,"lng":25.471700994064193},"occupied":0},
        {"slot":28,"center":{"lat":65.0589709196298,"lng":25.471757320453506},"occupied":1},
        {"slot":29,"center":{"lat":65.0589234155743,"lng":25.471762684871535},"occupied":1},
        {"slot":30,"center":{"lat":65.0589245466242,"lng":25.471703676273208},"occupied":1},
        {"slot":31,"center":{"lat":65.0589256776741,"lng":25.47165539651094},"occupied":0},
        {"slot":32,"center":{"lat":65.0589234155743,"lng":25.471596387912612},"occupied":1},
        {"slot":33,"center":{"lat":65.0589245466242,"lng":25.471542743732314},"occupied":1},
        {"slot":34,"center":{"lat":65.0589245466242,"lng":25.47149714617906},"occupied":1},
        {"slot":35,"center":{"lat":65.0589234155743,"lng":25.471438137580733},"occupied":0},
        {"slot":36,"center":{"lat":65.0589234155743,"lng":25.471389857818465},"occupied":1},
        {"slot":37,"center":{"lat":65.0589222845243,"lng":25.471333531429153},"occupied":0},
        {"slot":38,"center":{"lat":65.0589222845243,"lng":25.471279887248855},"occupied":0},
        {"slot":39,"center":{"lat":65.0589211534743,"lng":25.471226243068557},"occupied":1},
        {"slot":40,"center":{"lat":65.0589222845243,"lng":25.47117259888826},"occupied":1},
        {"slot":41,"center":{"lat":65.0589222845243,"lng":25.471127001335006},"occupied":1},
        {"slot":42,"center":{"lat":65.0589211534743,"lng":25.471070674945693},"occupied":1},
        {"slot":43,"center":{"lat":65.0589211534743,"lng":25.47101971297441},"occupied":1},
        {"slot":44,"center":{"lat":65.0589200224242,"lng":25.470968751003127},"occupied":1},
        {"slot":45,"center":{"lat":65.0589222845243,"lng":25.470912424613815},"occupied":1},
        {"slot":46,"center":{"lat":65.0589222845243,"lng":25.47086146264253},"occupied":1},
        {"slot":47,"center":{"lat":65.0589234155743,"lng":25.47079977183519},"occupied":1},
        {"slot":48,"center":{"lat":65.0589222845243,"lng":25.47075149207292},"occupied":1},
        {"slot":49,"center":{"lat":65.0589211534743,"lng":25.47069516568361},"occupied":1},
        {"slot":50,"center":{"lat":65.0589200224242,"lng":25.470644203712325},"occupied":1},
        {"slot":51,"center":{"lat":65.0589200224242,"lng":25.470587877323013},"occupied":1},
        {"slot":52,"center":{"lat":65.0589211534743,"lng":25.47053691535173},"occupied":1},
        {"slot":53,"center":{"lat":65.0589200224242,"lng":25.470477906753402},"occupied":1},
        {"slot":54,"center":{"lat":65.0589200224242,"lng":25.470429626991134},"occupied":1},
        {"slot":55,"center":{"lat":65.0589211534743,"lng":25.470381347228866},"occupied":1},
        {"slot":56,"center":{"lat":65.0589211534743,"lng":25.470325020839553},"occupied":0},
        {"slot":57,"center":{"lat":65.0588204898301,"lng":25.47037330060182},"occupied":1},
        {"slot":58,"center":{"lat":65.0588216208844,"lng":25.470434991409164},"occupied":1},
        {"slot":59,"center":{"lat":65.0588193587757,"lng":25.470485953380447},"occupied":1},
        {"slot":60,"center":{"lat":65.0588216208844,"lng":25.470539597560744},"occupied":1},
        {"slot":61,"center":{"lat":65.0588204898301,"lng":25.470595923950057},"occupied":1},
        {"slot":62,"center":{"lat":65.0588182277213,"lng":25.470649568130355},"occupied":1},
        {"slot":63,"center":{"lat":65.0588182277213,"lng":25.470703212310653},"occupied":1},
        {"slot":64,"center":{"lat":65.0588216208844,"lng":25.47075685649095},"occupied":0},
        {"slot":65,"center":{"lat":65.0588238829928,"lng":25.470807818462234},"occupied":1},
        {"slot":66,"center":{"lat":65.0588204898301,"lng":25.470856098224502},"occupied":1},
        {"slot":67,"center":{"lat":65.0588182277213,"lng":25.4709097424048},"occupied":1},
        {"slot":68,"center":{"lat":65.0588170966669,"lng":25.470966068794112},"occupied":0},
        {"slot":69,"center":{"lat":65.0588204898301,"lng":25.47101434855638},"occupied":1},
        {"slot":70,"center":{"lat":65.0588204898301,"lng":25.47112968354402},"occupied":1},
        {"slot":71,"center":{"lat":65.0588216208844,"lng":25.471180645515304},"occupied":1},
        {"slot":72,"center":{"lat":65.0588193587757,"lng":25.471231607486587},"occupied":1},
        {"slot":73,"center":{"lat":65.0588193587757,"lng":25.4712879338759},"occupied":1},
        {"slot":74,"center":{"lat":65.0588204898301,"lng":25.471336213638168},"occupied":1},
        {"slot":75,"center":{"lat":65.0588204898301,"lng":25.47139790444551},"occupied":1},
        {"slot":76,"center":{"lat":65.0588216208844,"lng":25.471446184207778},"occupied":1},
        {"slot":77,"center":{"lat":65.0588193587757,"lng":25.471499828388076},"occupied":1},
        {"slot":78,"center":{"lat":65.0588204898301,"lng":25.47155079035936},"occupied":0},
        {"slot":79,"center":{"lat":65.0588182277213,"lng":25.47165539651094},"occupied":1},
        {"slot":80,"center":{"lat":65.0588204898301,"lng":25.471706358482223},"occupied":1},
        {"slot":81,"center":{"lat":65.0588182277213,"lng":25.47176000266252},"occupied":1},
        {"slot":82,"center":{"lat":65.0587741165627,"lng":25.471768049289565},"occupied":1},
        {"slot":83,"center":{"lat":65.058775247619,"lng":25.471706358482223},"occupied":0},
        {"slot":84,"center":{"lat":65.058775247619,"lng":25.471658078719955},"occupied":1},
        {"slot":85,"center":{"lat":65.0587763786752,"lng":25.471601752330642},"occupied":1},
        {"slot":86,"center":{"lat":65.0587729855064,"lng":25.47155079035936},"occupied":0},
        {"slot":87,"center":{"lat":65.0587729855064,"lng":25.471494463970046},"occupied":1},
        {"slot":88,"center":{"lat":65.058775247619,"lng":25.471446184207778},"occupied":1},
        {"slot":89,"center":{"lat":65.0587763786752,"lng":25.471400586654525},"occupied":1},
        {"slot":90,"center":{"lat":65.0587741165627,"lng":25.471341578056197},"occupied":0},
        {"slot":91,"center":{"lat":65.0587729855064,"lng":25.471290616084914},"occupied":1},
        {"slot":92,"center":{"lat":65.05877185445,"lng":25.471231607486587},"occupied":1},
        {"slot":93,"center":{"lat":65.0587763786752,"lng":25.47118332772432},"occupied":1},
        {"slot":94,"center":{"lat":65.0587741165627,"lng":25.471127001335006},"occupied":1},
        {"slot":95,"center":{"lat":65.0587729855064,"lng":25.471070674945693},"occupied":1},
        {"slot":96,"center":{"lat":65.0587729855064,"lng":25.47101971297441},"occupied":1},
        {"slot":97,"center":{"lat":65.05877185445,"lng":25.470971433212142},"occupied":1},
        {"slot":98,"center":{"lat":65.058775247619,"lng":25.47091510682283},"occupied":1},
        {"slot":99,"center":{"lat":65.0587707233936,"lng":25.470700530101638},"occupied":1},
        {"slot":100,"center":{"lat":65.0587729855064,"lng":25.47064688592134},"occupied":1},
        {"slot":101,"center":{"lat":65.0587729855064,"lng":25.470590559532027},"occupied":1},
        {"slot":102,"center":{"lat":65.05877185445,"lng":25.470539597560744},"occupied":1},
        {"slot":103,"center":{"lat":65.05877185445,"lng":25.47049400000749},"occupied":1},
        {"slot":104,"center":{"lat":65.05877185445,"lng":25.47043767361818},"occupied":1},
        {"slot":105,"center":{"lat":65.05877185445,"lng":25.470381347228866},"occupied":1},
        {"slot":106,"center":{"lat":65.0586655349379,"lng":25.470386711646896},"occupied":1},
        {"slot":107,"center":{"lat":65.058664403877,"lng":25.470440355827193},"occupied":1},
        {"slot":108,"center":{"lat":65.0586655349379,"lng":25.47049400000749},"occupied":1},
        {"slot":109,"center":{"lat":65.0586666659988,"lng":25.470539597560744},"occupied":1},
        {"slot":110,"center":{"lat":65.058664403877,"lng":25.470590559532027},"occupied":1},
        {"slot":111,"center":{"lat":65.0586666659988,"lng":25.47064688592134},"occupied":1},
        {"slot":112,"center":{"lat":65.0586666659988,"lng":25.470697847892623},"occupied":1},
        {"slot":113,"center":{"lat":65.058663272816,"lng":25.470754174281936},"occupied":1},
        {"slot":114,"center":{"lat":65.0586655349379,"lng":25.47081050067125},"occupied":1},
        {"slot":115,"center":{"lat":65.058664403877,"lng":25.470858780433517},"occupied":1},
        {"slot":116,"center":{"lat":65.058663272816,"lng":25.470912424613815},"occupied":1},
        {"slot":117,"center":{"lat":65.058662141755,"lng":25.470974115421157},"occupied":1},
        {"slot":118,"center":{"lat":65.058664403877,"lng":25.471022395183425},"occupied":1},
        {"slot":119,"center":{"lat":65.058663272816,"lng":25.471065310527663},"occupied":1},
        {"slot":120,"center":{"lat":65.058664403877,"lng":25.471127001335006},"occupied":1},
        {"slot":121,"center":{"lat":65.0586666659988,"lng":25.47118332772432},"occupied":0},
        {"slot":122,"center":{"lat":65.058664403877,"lng":25.471228925277572},"occupied":1},
        {"slot":123,"center":{"lat":65.058664403877,"lng":25.471285251666885},"occupied":1},
        {"slot":124,"center":{"lat":65.058664403877,"lng":25.471341578056197},"occupied":0},
        {"slot":125,"center":{"lat":65.058663272816,"lng":25.471389857818465},"occupied":1},
        {"slot":126,"center":{"lat":65.058662141755,"lng":25.47144081978975},"occupied":1},
        {"slot":127,"center":{"lat":65.058664403877,"lng":25.47149714617906},"occupied":1},
        {"slot":128,"center":{"lat":65.0586655349379,"lng":25.471548108150344},"occupied":1},
        {"slot":129,"center":{"lat":65.0586666659988,"lng":25.471601752330642},"occupied":1},
        {"slot":130,"center":{"lat":65.0586689281204,"lng":25.47166076092897},"occupied":1},
        {"slot":131,"center":{"lat":65.0586677970596,"lng":25.471711722900253},"occupied":1},
        {"slot":132,"center":{"lat":65.0586700591811,"lng":25.471762684871535},"occupied":1},
        {"slot":133,"center":{"lat":65.0586202924637,"lng":25.47177073149858},"occupied":0},
        {"slot":134,"center":{"lat":65.0586202924637,"lng":25.471711722900253},"occupied":1},
        {"slot":135,"center":{"lat":65.0586236856519,"lng":25.47166076092897},"occupied":1},
        {"slot":136,"center":{"lat":65.0586202924637,"lng":25.471601752330642},"occupied":1},
        {"slot":137,"center":{"lat":65.0586225545892,"lng":25.47155079035936},"occupied":1},
        {"slot":138,"center":{"lat":65.0586225545892,"lng":25.471494463970046},"occupied":1},
        {"slot":139,"center":{"lat":65.0586214235265,"lng":25.471451548625808},"occupied":1},
        {"slot":140,"center":{"lat":65.0586202924637,"lng":25.47139254002748},"occupied":1},
        {"slot":141,"center":{"lat":65.0586202924637,"lng":25.471338895847182},"occupied":1},
        {"slot":142,"center":{"lat":65.0586202924637,"lng":25.47129329829393},"occupied":1},
        {"slot":143,"center":{"lat":65.0586191614009,"lng":25.47123965411363},"occupied":1},
        {"slot":144,"center":{"lat":65.0586202924637,"lng":25.471191374351363},"occupied":1},
        {"slot":145,"center":{"lat":65.0586191614009,"lng":25.47112431912599},"occupied":1},
        {"slot":146,"center":{"lat":65.0586202924637,"lng":25.471078721572738},"occupied":0},
        {"slot":147,"center":{"lat":65.0586202924637,"lng":25.47101971297441},"occupied":1},
        {"slot":148,"center":{"lat":65.0586191614009,"lng":25.470971433212142},"occupied":1},
        {"slot":149,"center":{"lat":65.0586191614009,"lng":25.470917789031844},"occupied":1},
        {"slot":150,"center":{"lat":65.0586191614009,"lng":25.47086146264253},"occupied":1},
        {"slot":151,"center":{"lat":65.058616899275,"lng":25.470813182880264},"occupied":1},
        {"slot":152,"center":{"lat":65.058618030338,"lng":25.47075685649095},"occupied":1},
        {"slot":153,"center":{"lat":65.058618030338,"lng":25.470705894519668},"occupied":1},
        {"slot":154,"center":{"lat":65.058618030338,"lng":25.470654932548385},"occupied":1},
        {"slot":155,"center":{"lat":65.058618030338,"lng":25.470593241741042},"occupied":1},
        {"slot":156,"center":{"lat":65.0586191614009,"lng":25.470550326396804},"occupied":1},
        {"slot":157,"center":{"lat":65.058618030338,"lng":25.47049400000749},"occupied":1},
        {"slot":158,"center":{"lat":65.0586202924637,"lng":25.470445720245223},"occupied":1},
        {"slot":159,"center":{"lat":65.058618030338,"lng":25.47037866501985},"occupied":1},
        {"slot":160,"center":{"lat":65.0588185457004,"lng":25.47160526826023},"occupied":0},
    ]
};

/* GoogleApiWrapper({
    apiKey: process.env.REACT_APP_GOOGLE_API_KEY
    })(MapWindow);   */
