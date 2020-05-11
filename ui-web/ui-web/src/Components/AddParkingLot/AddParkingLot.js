import React, { Component } from 'react';
import axios from 'axios';
import styles from './AddParkingLot.module.css';

const axiosPost=(parkingData)=>{
    axios.post('https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/parkinglot', parkingData, {
        headers: {
            "x-api-key": process.env.REACT_APP_DATABASE_API_KEY, 
            "Content-Type": "application/json",
            "confirmation": 1 // Tarvitaan vain silloin kun päivitetään olemassaolevan parkkialueen slottidataa
        },
        crossDomain: true,
        })
    .then(response => {
        console.log(response.data)
        //this.setState({loadingReady: true})
    }).catch((error) => {
        console.log(error)
    })
}

//samanlainen kuin axiosPOst, mutta sen sisällä kasataan inputeista saatava data json -paketiksi

let parkingLotData = null;

class AddParkingLot extends React.Component {

    render(){
        return(
            <form style={{textAlign: "left"}}>
                <br></br>
                <link rel="stylesheet" href="AddParkingLot"></link>

                <input
                    className={styles.InputName}
                    type="text"
                    name="name"
                    placeholder="Name"
                    ref={input => this.name = input}></input><br></br>

                <input
                    className={styles.InputName}
                    type="text"
                    name="city"
                    placeholder="City"
                    ref={input => this.city = input}></input><br></br>

                <input
                    className={styles.InputPath}
                    type="text"
                    name="polygonpath"
                    placeholder="Path coordinates"
                    ref={input => this.polygonpath = input}></input><br></br>

                <input
                    className={styles.InputSlots}
                    type="text"
                    name="slots"
                    placeholder="Slot coordinates"
                    ref={input => this.slots = input}></input><br></br><br></br>

                <input
                    //className="w3-button w3-white w3-border w3-border-gray w3-round-large"
                    className={styles.Button}
                    type="submit"
                    value="Submit"
                    onClick={console.log("TESTI")}></input>

            </form>

        );
    }
};

export default AddParkingLot;