import React, { Component } from 'react';

import classes from './Body.module.css';

class BurgerIngredients extends Component {
	render() {
		return(
		<div className={classes.Body}>
            <p>Tähän valmistuu Parkissa-projektin nettisivu.</p>
        </div>
		);
	}

};

export default BurgerIngredients;