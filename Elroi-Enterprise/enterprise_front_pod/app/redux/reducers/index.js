import { combineReducers } from 'redux';
import { authReducer, authInitialState } from './auth';

const appReducer = combineReducers({
  auth: authReducer,
});

export function rootReducer(state, action) {
  return appReducer(state, action);
}

export const AppState = {
  auth: authInitialState,
};
