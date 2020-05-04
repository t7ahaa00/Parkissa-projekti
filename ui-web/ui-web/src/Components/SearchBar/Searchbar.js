import React from 'react';
import Aux from '../../hoc/Auxiliary/Auxiliary';
import Spinner from '../../Components/Spinner/Spinner';

//import classes from './SearchBar.module.css';

const handleApiLoaded = (serverTestParkData) => {
    // use map and maps objects
    serverTestParkData.map((serverData, index) => {
        return(
            serverData.parkingareas.map((parkAreas, index) => {
                console.log('[ParkAreas] ' + JSON.stringify(parkAreas.name))
                
                return(
                    /*new maps.Polygon({
                        strokeColor: '#FF0000',
                        strokeOpacity: 0.8,
                        strokeWeight: 2,
                        fillColor: '#888888',
                        fillOpacity: 0.1,
                        map,
                        path: parkAreas.path,
                    })*/
                    <option>{JSON.stringify(parkAreas.name)}</option>
                )
            })
        )
    })
};

const getParkingAreaNames = (serverTestParkData) => {

    return(

        <datalist id="suggestions">

        {serverTestParkData.map((serverData, index) => {
            console.log('[ParkArea names] ' + JSON.stringify(serverData.name))
            return(
                <option>{JSON.stringify(serverData.name)}</option>
            )
        })}
        
        </datalist>
    )
};

class Search extends React.Component {
    
    constructor(props){
        super(props);

        //this.getParkingAreaNames = this.getParkingAreaNames.bind(this);
    }

    render() {
        let displayNames = this.props.serverData !== null ? <p>Loading...</p> : <Spinner />;
        
        if (this.props.serverData !== null) {
            
            displayNames = (

                <div>
                    {getParkingAreaNames(this.props.serverData)}
                    {console.log(getParkingAreaNames(this.props.serverData))}
                    <input  autoComplete="on" list="suggestions"/>
                </div>

                    

            );
        }

        return(
            <Aux>
                    {displayNames}
            </Aux>
        )
    }
}
export default Search;

/*

<div style={{ height: '90vh', width: '100%', zIndex: 3, position: "absolute", top: 0, bottom: 0 }}>
                    <input  autoComplete="on" list="suggestions"/> 
                    <datalist id="suggestions">
                        {getParkingAreaNames(this.props.serverData)}
                        {console.log(getParkingAreaNames(this.props.serverData))}
                        </datalist>
                        </div>


<div>
                    <datalist id="suggestions">
                        {displayNames}
                    </datalist>
                    <input  autoComplete="on" list="suggestions"/> 
                </div>

*/


/*<div>
                <input type="text" name="search" placeholder="Search..">
                    <a href="#about">About</a>
                    <a href="#base">Base</a>

                </input>
            </div>*/