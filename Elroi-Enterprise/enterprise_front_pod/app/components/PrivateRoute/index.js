import React, { Component } from 'react';
import { Redirect, Route } from 'react-router-dom';
import authUtils from '../../utils/api/auth';
import routes from '../../constants/routes.json';

const PrivateRoute = ({ component: Component, componentProps, ...rest }) => <Route {...rest}
    render={(props) => authUtils.loggedIn() ? (<Component {...props} {...componentProps}></Component>) : <Redirect to={{ pathname: routes.LOGIN, state: { from: props.location } }}></Redirect>}></Route>

export default PrivateRoute;