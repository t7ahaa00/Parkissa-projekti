import React, { Component } from 'react';
import { InfoWindow } from 'google-maps-react';

import ParkDetailOverlay from '../ParkDetailOverlay/ParkDetailOverlay'

class ParkInfoWindows extends Component {
    
     

    render(){
        const pos = JSON.stringify(this.props.position);
        console.log("pos: " + pos + ", vis: " + this.props.visible + ", name: " + this.props.name);

    return(
        <InfoWindow 
            position={pos}
            visible={this.props.visible}
            name={this.props.name}>
            <ParkDetailOverlay />
        </InfoWindow>
    );
    }
};

export default ParkInfoWindows;