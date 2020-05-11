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

function storeJsonData(){
    const name = document.getElementById("formData").name.value
    const city = document.getElementById("formData").city.value
    const pathArray = document.getElementById("formData").polygonpath.value
    const slotsArray = document.getElementById("formData").slots.value
    const apiData = { name: name, city: city, path: JSON.parse("["+pathArray+"]"), slots: JSON.parse("["+slotsArray+"]") };
    //const json = JSON.parse(apiData);
    console.log(apiData);
    console.log(slotsArray);
    axiosPost(apiData)
}
//samanlainen kuin axiosPOst, mutta sen sisällä kasataan inputeista saatava data json -paketiksi

//let parkingLotData = null;

//{"slot":1,"occupied":1,"center":{"lat":65.0589675264858,"lng":25.470319656421523}},         {"slot":2,"occupied":1,"center":{"lat":65.0589697885818,"lng":25.470370618392806}}

class AddParkingLot extends React.Component {

    render(){
        return(
            <form style={{textAlign: "left"}} id="formData"> 
                <br></br>
                <link rel="stylesheet" href="AddParkingLot"></link>

                <input
                    className={styles.InputName}
                    type="text"
                    name="name"
                    id="name"
                    placeholder="Name"
                    ref={input => this.name = input}></input><br></br>

                <input
                    className={styles.InputName}
                    type="text"
                    name="city"
                    id="city"
                    placeholder="City"
                    ref={input => this.city = input}></input><br></br>

                <input
                    className={styles.InputPath}
                    type="text"
                    name="polygonpath"
                    id="polygonpath"
                    placeholder="Path coordinates"
                    ref={input => this.polygonpath = input}></input><br></br>

                <input
                    className={styles.InputSlots}
                    type="text"
                    name="slots"
                    id="slots"
                    placeholder="Slot coordinates"
                    ref={input => this.slots = input}></input><br></br><br></br>

                <input
                    //className="w3-button w3-white w3-border w3-border-gray w3-round-large"
                    className={styles.Button}
                    type="submit"
                    value="Submit"
                    onClick={storeJsonData}></input>

            </form>

        );
    }
};

export default AddParkingLot;