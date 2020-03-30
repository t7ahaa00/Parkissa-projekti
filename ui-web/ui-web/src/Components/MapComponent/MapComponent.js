import React, { Component } from 'react';
import { Map, GoogleApiWrapper, Marker, Polygon } from 'google-maps-react';

import classes from './MapComponent.module.css';

class MapComponent extends Component {

    constructor(props) {
        super(props);
        //this.onScriptLoad = this.onScriptLoad.bind(this)

        this.state= {
            parkSites: [
                {lat: 65.0594, lng: 25.4711},
                {lat: 65.061, lng: 25.4638},
                {lat: 65.0582, lng: 25.4622},
            ],
            //position: this.google.maps.ControlPosition.LEFT_BOTTOM
        }
        //this.googleMapRef = React.createRef();
    }

    // onScriptLoad() {
    //     const map = new window.google.maps.Map(
    //       document.getElementById(this.props.id),
    //       this.props.options);
    //     this.props.onMapLoad(map)
    //   }
    
    //componentDidMount() {
        // if (!window.google) {
        //     var s = document.createElement('script');
        //     s.type = 'text/javascript';
        //     s.src = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyD38KVBa8COxekeVYZz9ypRqwUGKuJQkrM&libraries=places';
        //     var x = document.getElementsByTagName('script')[0];
        //     x.parentNode.insertBefore(s, x);
        //     // Below is important. 
        //     //We cannot access google.maps until it's finished loading
        //     s.addEventListener('load', e => {
        //       this.onScriptLoad()
        //     })
        //   } else {
        //     this.onScriptLoad()
        //   }
          
    //     const googleMapScript = document.createElement('script');
        
    //     googleMapScript.src = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyD38KVBa8COxekeVYZz9ypRqwUGKuJQkrM&libraries=places';
    //     googleMapScript.type = 'text/javascript';

    //     window.document.body.appendChild(googleMapScript);
        
    //     googleMapScript.addEventListener("load", () => {
    //         this.googleMap = this.createGoogleMap();
    //         this.marker = this.createMarker();
    //     });
    // }

    // createGoogleMap = () =>
    //     new window.google.maps.Map(this.googleMapRef.current, {
    //         zoom: 16,
    //         Center:{ 
    //             lat: 65.0595, 
    //             lng: 25.4662
    //         }
    //     });

    // createMarker = () => new window.google.maps.Marker({
    //     position: {lat: 65.0594, lng: 25.4711},
    //     map: this.googleMap
    // });

    displaySites = () => {
        return this.state.parkSites.map((parkSite, index) => {
            return <Marker key={index} id={index} position={{
                lat: parkSite.lat,
                lng: parkSite.lng
            }} />
        })
    }

    // mapOptionsCreator = (props) => {
    //     return  {
    //       position: props.ControlPosition.LEFT_BOTTOM
    //     };
    //   }
      
    render() {

        const triangleCoords = [
            {lat: 65.060014, lng: 25.470085},
            {lat: 65.060014, lng: 25.471944},
            {lat: 65.058479, lng: 25.471944},
            {lat: 65.058479, lng: 25.470085}
          ];

          const polygonCoordsA = [

            //65.061034, 25.463066
            //65.060469, 25.464655
            {lat: 65.061034, lng: 25.463066},
            {lat: 65.061034, lng: 25.464645},
            {lat: 65.060467, lng: 25.464645},
            {lat: 65.060467, lng: 25.463066}
          ];

          const polygonCoordsB = [

            //65.058564, 25.461579
            //65.057540, 25.463075
            {lat: 65.058564, lng: 25.461579},
            {lat: 65.058564, lng: 25.463075},
            {lat: 65.057540, lng: 25.463075},
            {lat: 65.057540, lng: 25.461579}
          ];

        return(
            <Map
                google={this.props.google}
                zoom={16}
                className={classes.Map}
                initialCenter={{ lat: 65.0595, lng: 25.4662}}
                mapTypeControl={true}
                //mapTypeControlOptions={this.state.position}
                >
                <Polygon
                    paths={triangleCoords}
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
        </Map>
        );
    }
};

export default GoogleApiWrapper({
    apiKey: 'AIzaSyD38KVBa8COxekeVYZz9ypRqwUGKuJQkrM'
    })(MapComponent);

//<div className={classes.Map} id={this.props.id} />

// <div 
            //     id="google-map"
            //     ref={this.googleMapRef}
            //     className={classes.Map} />

// export default GoogleApiWrapper({
//     apiKey: 'AIzaSyD38KVBa8COxekeVYZz9ypRqwUGKuJQkrM'
// })(MapComponent);

//     <Map
        //   google={this.props.google}
        //   zoom={16}
        //   className={classes.Map}
        //   initialCenter={{ lat: 65.0595, lng: 25.4662}}
        //   mapTypeControl={true}
        //   mapTypeControlOptions={this.mapOptionsCreator}


        // >
        //     {this.displaySites()}
        // </Map>