import React from 'react';
import Aux from '../../hoc/Auxiliary/Auxiliary';
import Spinner from '../../Components/Spinner/Spinner';

import classes from './SearchBar.module.css';

var id
var otherProps

var idKeyPressed

const handleApiLoaded = (serverTestParkData) => {
    // use map and maps objects
    serverTestParkData.map((serverData, index) => {
        return(
            serverData.parkingareas.map((parkAreas, index) => {
                console.log('[ParkAreas] ' + JSON.stringify(parkAreas.name))
                
                return(
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
                <option key={index}>{modifiedString}</option>
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

                centerCoords = serverData.parkingareas[0].path[0]
                console.log(centerCoords)
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

            if(id && idKeyPressed !== id) {
                console.log('user search', id);
                setId(id, otherProps);
                idKeyPressed = id;
            }
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