import React from 'react';
import Aux from '../../hoc/Auxiliary/Auxiliary';
import Spinner from '../../Components/Spinner/Spinner';

import classes from './SearchBar.module.css';

var id
var otherProps

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

const removeQuotes = (str) => {
    let newstr = str.replace(/\"/g, '');
    return newstr;
}

const getParkingAreaNames = (serverTestParkData) => {

    return(

        <datalist id="suggestions">

        {serverTestParkData.map((serverData, index) => {
            console.log('[ParkArea names] ' + JSON.stringify(serverData.name))
            let modifiedString = removeQuotes(serverData.name);
            return(
                <option>{modifiedString}</option>
            )
        })}
        
        </datalist>
    )
};

const getCenterData = (serverTestParkData, id) => {
    var centerCoords = null;
    console.log(id)
    
        serverTestParkData.map((serverData, index) => {
            
            if (serverData.name === id) {
                console.log('ONE HIT!!! ' + JSON.stringify(serverData.parkingareas[0].path[0]))

                //var test = removeQuotes(JSON.stringify(serverData.parkingareas[0].path[0]))
                //var testJSON = JSON.parse(test);
                centerCoords = serverData.parkingareas[0].path[0]
                console.log(centerCoords)
                
                /*this.state= {
                    serverParkData: null,
                    center: {
                        lat: 65.0595, lng: 25.4662
                    }
                }*/

                //test2 = {center: {test}}
                
            }
            
        })
    return (centerCoords);
}

const setId = (toId, props) => {
    id = toId
    console.log('id set to= ', id);
    var centerDataObject = getCenterData(props.serverData, id)
    props.handleToUpdate(centerDataObject)
}


class Search extends React.Component {

    onKeyPressed(props) {
        
        if (props.key === 'Enter') {
            const id = props.target.value;
            console.log('user search', id);
            setId(id, otherProps);
        }
    }

    render() {
        let displayNames = this.props.serverData !== null ? <p>Loading...</p> : <Spinner />;

        otherProps = this.props
        
        if (this.props.serverData !== null) {
            
            displayNames = (

                <div>
                    {getParkingAreaNames(this.props.serverData)}
                    {console.log(getParkingAreaNames(this.props.serverData))}
                    <input className={classes.input} type="search" placeholder="Search parkinglots" autoComplete="on" list="suggestions" onKeyPress={this.onKeyPressed}/>
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