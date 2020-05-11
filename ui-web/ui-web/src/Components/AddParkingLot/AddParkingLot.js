import React, { Component } from 'react';

import styles from './AddParkingLot.module.css';


class AddParkingLot extends React.Component {

    render(){
        return(
            <form style={{textAlign: "left"}}>
                <br></br>
                <link rel="stylesheet" href="AddParkingLot"></link>

                <input
                    className={styles.Inputit}
                    type="text"
                    name="name"
                    placeholder="Name"
                    ref={input => this.name = input}></input><br></br>

                <input
                    className={styles.Inputit}
                    type="text"
                    name="city"
                    placeholder="City"
                    ref={input => this.city = input}></input><br></br>

                <input
                    className={styles.Inputit}
                    type="text"
                    name="polygonpath"
                    placeholder="Path coordinates"
                    ref={input => this.polygonpath = input}></input><br></br>

                <input
                    className={styles.Inputit}
                    type="text"
                    name="slots"
                    placeholder="Slot coordinates"
                    ref={input => this.slots = input}></input><br></br><br></br>

                <input
                    className="w3-button w3-white w3-border w3-border-gray w3-round-large"
                    type="submit"
                    value="Submit"
                    onClick={console.log("TESTI")}></input>

            </form>

        );
    }
};

export default AddParkingLot;