import {
  LOGIN_REQUEST,
  LOGOUT,
  SENDING_REQUEST,
  CLEAR_ERROR,
  REQUEST_ERROR,
  SIGNUP_REQUEST
} from '../../../constants/actionTypes';

/**
 * Sets the `currentlySending` state, which displays a loading indicator during requests
 * @param  {boolean} sending True means we're sending a request, false means we're not
 */
export function sendingRequest(sending) {
  return {
    type: SENDING_REQUEST,
    sending,
  };
}

/**
 * Tells the app we want to log in a user
 * @param  {object} data          The data we're sending for log in
 * @param  {string} data.username The username of the user to log in
 * @param  {string} data.password The password of the user to log in
 */
export function loginRequest(data) {
  return {
    type: LOGIN_REQUEST,
    data,
  };
}

export function signUpRequest(data) {
  return {
    type: SIGNUP_REQUEST,
    data,
  };
}

/**
 * Tells the app we want to log out a user
 */
export function logout() {
  return {
    type: LOGOUT,
  };
}

export function requestError(error) {
  return {
    type: REQUEST_ERROR,
    error,
  };
}

/**
 * Sets the `error` state as empty
 */
export function clearError() {
  return {
    type: CLEAR_ERROR,
  };
}
