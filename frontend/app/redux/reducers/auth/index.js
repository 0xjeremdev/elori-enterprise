import {
  SET_AUTH,
  SENDING_REQUEST,
  REQUEST_ERROR,
  CLEAR_ERROR,
  SIGNUP_REQUEST_ERROR,
  SENDING_SIGNUP_REQUEST,
  SIGNUP_REQUEST_SUCCESS,
  SENDING_VERIFY_CODE,
} from "../../../constants/actionTypes";
import { sendVerifyCode } from "../../../utils/api/auth";

export const authInitialState = {
  public_id: null,
  first_name: null,
  last_name: null,
  require_2fa: null,
  token: null,
  currentlySending: false,
  loggedIn: false,
  loginError: null,
  signupError: null,
  currentlySendingSignup: false,
  sentSignupRequest: false,
};

export function authReducer(state = authInitialState, action) {
  switch (action.type) {
    case SET_AUTH:
      return { ...state, ...action.newAuthState };

    case SENDING_REQUEST:
      return { ...state, currentlySending: action.sending };

    case REQUEST_ERROR:
      return { ...state, loginError: action.error };

    case SIGNUP_REQUEST_ERROR:
      return {
        ...state,
        signupError: action.error,
        currentlySendingSignup: false,
      };

    case CLEAR_ERROR:
      return { ...state, loginError: "" };

    case SENDING_SIGNUP_REQUEST:
      return { ...state, currentlySendingSignup: action.sending };

    case SIGNUP_REQUEST_SUCCESS:
      return { ...state, sentSignupRequest: action.success };

    case SENDING_VERIFY_CODE:
      // sendVerifyCode();
      return { ...state };

    default:
      return state;
  }
}
