/**
 *
 * App
 *
 * This component is the skeleton around the actual pages, and should only
 * contain code that should be seen on all pages. (e.g. navigation bar)
 */

import React from 'react';
import { Switch, Route } from 'react-router-dom';
import routes from 'constants/routes.json';
import Login from '../LoginPage';
import Request from '../Dashboard/Request';
import Signup from '../LoginPage/SignupPage';
import EmailConfirm from '../LoginPage/EmailConfirm';
import VerifyCode from '../LoginPage/VerifyCode';
import Dashboard from '../Dashboard';
import PrivateRoute from '../../components/PrivateRoute';

export default function App() {
  return (
    <Switch>
      <Route exact path={routes.LOGIN} component={Login} />
      <Route exact path={routes.SIGNUP} component={Signup} />
      <Route exact path={routes.EMAILCONFIRM} component={EmailConfirm} />
      <Route path={routes.REQUEST} component={Request} />
      <PrivateRoute exact path={routes.VERIFYCODE} component={VerifyCode} />
      <PrivateRoute path={routes.DASHBOARD} component={Dashboard} />
    </Switch>
  );
}
