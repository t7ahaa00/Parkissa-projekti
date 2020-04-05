import React from 'react';

import classes from './Header.module.css';

const Header = (props) => {

    return(
        <div className={classes.Header}>
            <img className={classes.Img} src={require('../../assets/PARKSIGHT_logo_transparent.png')} alt="Logo"></img>
        </div>
    );
};

export default Header;