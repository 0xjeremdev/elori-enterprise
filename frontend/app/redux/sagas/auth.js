import history from 'utils/history';
import { take, call, put, fork, race } from 'redux-saga/effects';
import auth from '../../utils/api/auth';
import {
  SET_AUTH,
  LOGIN_REQUEST,
  SIGNUP_REQUEST,
  LOGOUT,
  SENDING_REQUEST,
  REQUEST_ERROR,
  CLEAR_ERROR,
  SIGNUP_REQUEST_ERROR,
  SENDING_SIGNUP_REQUEST,
  SIGNUP_REQUEST_SUCCESS,
  SENDING_VERIFY_CODE,
} from '../../constants/actionTypes';

export function* authorize({ email, password, isRegistering }) {
  // We send an action that tells Redux we're sending a request
  yield put({ type: SENDING_REQUEST, sending: true });

  // We then try to register or log in the user, depending on the request
  try {
    let response;

    // For either log in or registering, we call the proper function in the `auth`
    // module, which is asynchronous. Because we're using generators, we can work
    // as if it's synchronous because we pause execution until the call is done
    // with `yield`!
    if (isRegistering) {
      response = yield call(auth.register, email, password);
    } else {
      response = yield call(auth.login, email, password);
    }
    if (response.success && response.data && response.data.tokens) {
      // yield put({ type: SET_AUTH, newAuthState: response.data }); // User is logged in (authorized)
      yield put({ type: CLEAR_ERROR }); // User is logged in (authorized)
      return true;
    }
    yield put({ type: REQUEST_ERROR, error: response.message });
    return false;
  } catch (error) {
    // If we get an error we send Redux the appropiate action and return
    yield put({ type: REQUEST_ERROR, error: error.error });
    return false;
  } finally {
    // When done, we tell Redux we're not in the middle of a request any more
    yield put({ type: SENDING_REQUEST, sending: false });
  }
}

/**
 * Effect to handle logging out
 */
export function* logout() {
  // eslint-disable-line consistent-return
  // We tell Redux we're in the middle of a request
  yield put({ type: SENDING_REQUEST, sending: true });

  // Similar to above, we try to log out by calling the `logout` function in the
  // `auth` module. If we get an error, we send an appropiate action. If we don't,
  // we return the response.
  try {
    const response = yield call(auth.logout);
    yield put({ type: SENDING_REQUEST, sending: false });

    return response;
  } catch (error) {
    yield put({ type: REQUEST_ERROR, error: error.message });
  }
}

export function* signup(request) {
  yield put({ type: SENDING_SIGNUP_REQUEST, sending: true })
  let response;
  // eslint-disable-line no-constant-condition

  try {
    response = yield call(auth.register, request.data);
    yield put({ type: SENDING_SIGNUP_REQUEST, sending: false })
    if (response.success) {
      yield put({ type: SIGNUP_REQUEST_SUCCESS, success: true })
    } else {
      yield put({ type: SIGNUP_REQUEST_SUCCESS, success: false })
    }
  } catch (error) {
    yield put({ type: SIGNUP_REQUEST_ERROR, error: error.error.errors })
    console.log(error, error.response)
  }
}

/**
 * Log in saga
 */
export function* loginFlow() {
  // Because sagas are generators, doing `while (true)` doesn't block our program
  // Basically here we say "this saga is always listening for actions"
  while (true) {
    // eslint-disable-line no-constant-condition
    // And we're listening for `LOGIN_REQUEST` actions and destructuring its payload
    const request = yield take(LOGIN_REQUEST);
    const { email, password } = request.data;
    // A `LOGOUT` action may happen while the `authorize` effect is going on, which may
    // lead to a race condition. This is unlikely, but just in case, we call `race` which
    // returns the "winner", i.e. the one that finished first
    const winner = yield race({
      auth: call(authorize, { email, password, isRegistering: false }),
      logout: take(LOGOUT),
    });
    // If `authorize` was the winner...
    if (winner.auth) {
      yield put({ type: SENDING_VERIFY_CODE })
      forwardTo("/consumer-request"); // Go to Verify code
    } else if (winner.logout) {
      // ...we send Redux appropiate action
      yield put({ type: SET_AUTH, newAuthState: {} }); // User is not logged in (not authorized)
      yield call(logout); // Call `logout` effect
      forwardTo('/login'); // Go to root page
    }
  }
}

/**
 * Sign up in saga
 */
export function* signupFlow() {
  // Because sagas are generators, doing `while (true)` doesn't block our program
  // Basically here we say "this saga is always listening for actions"
  while (true) {
    const request = yield take(SIGNUP_REQUEST);
    yield call(signup, request);
  }
}

/**
 * Log out saga
 * This is basically the same as the `if (winner.logout)` of above, just written
 * as a saga that is always listening to `LOGOUT` actions
 */
export function* logoutFlow() {
  while (true) {
    // eslint-disable-line no-constant-condition
    yield take(LOGOUT);
    yield put({ type: SET_AUTH, newAuthState: {} });

    yield call(logout);
    forwardTo('/login');
  }
}

export default function* root() {
  yield fork(loginFlow);
  yield fork(logoutFlow);
  yield fork(signupFlow);
}

// Little helper function to abstract going to different pages
function forwardTo(location) {
  history.push(location);
}
