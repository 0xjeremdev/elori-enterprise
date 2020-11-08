import axios from 'axios';
// import queryString from 'query-string';
import { API_ENDPOINT_URL } from '../../../constants/defaults';

let localStorage;

// If we're testing, use a local storage polyfill
if (global.process && process.env.NODE_ENV === 'test') {
  localStorage = require('localStorage');
} else {
  // If not, use the browser one
  const local = global.window.localStorage;
  localStorage = local;
}

const register = ({ newUserEmail, newUserName, newUserFName, newUserLName, newUserPwd }) => {
  try {
    return axios
      .post(`${API_ENDPOINT_URL}/register/enterprise/`, {
        email: newUserEmail,
        password: newUserPwd,
        name: newUserName,
        first_name: newUserFName,
        last_name: newUserLName,
        state_resident: true
      })
      .then((res) => {
        if (res.data && res.data.data && res.data.data.user) {
          setUserData(res.data.data.user);
          setToken(res.data.data.token);
          return Promise.resolve({ success: true, data: res.data.data.user });
        }
        return Promise.resolve({ success: false, reason: res.data.message });
      })
      .catch((err) =>
        Promise.reject({ success: false, error: err.response.data }),
      );
  } catch (error) {
    console.log(error, error.response)
  }

};

const login = (email, password) => {
  //   if (loggedIn())
  //     return Promise.resolve({ success: true, data: getUserData() });
  return axios
    .post(`${API_ENDPOINT_URL}/login/`, {
      email,
      password,
    })
    .then((res) => {
      if (res.data.email) {
        setUserData({ email: res.data.email, elroi_id: res.data.elroi_id, enterprise_id: res.data.enterprise_id, full_name: res.data.full_name, });
        setToken(res.data.tokens);
        return Promise.resolve({ success: true, data: res.data });
      }
      return Promise.resolve({ success: false, reason: res.data });
    })
    .catch((err) =>
      Promise.reject({ success: false, error: err.response.data }),
    );
};

const logout = () => {
  const { token } = getUserData();
  return axios
    .post(
      `${API_ENDPOINT_URL}/auth/logout`,
      {},
      {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      },
    )
    .then((res) => {
      clearUserData();
      Promise.resolve({ success: true });
    })
    .catch((err) => {
      clearUserData();
      Promise.resolve({
        success: false,
        reason: err.response.data.message || err.message,
      });
    });
};

const loggedIn = () => {
  const { token } = getUserData();
  return !!token;
};

const getUserData = () => {
  try {
    const ret = {
      token: localStorage.getItem('access-token'),
      email: localStorage.getItem('email'),
      first_name: localStorage.getItem('first_name'),
      last_name: localStorage.getItem('last_name'),
    };
    return ret;
  } catch (error) {
    return {};
  }
};
const setUserData = ({ email, elroi_id, enterprise_id,full_name, state_resident }) => {
  try {
    console.log(email, elroi_id, full_name, state_resident)
    localStorage.setItem('email', email);
    localStorage.setItem('elroi_id', elroi_id);
    localStorage.setItem('enterprise_id', enterprise_id);
    localStorage.setItem('full_name', full_name);
    localStorage.setItem('state_resident', state_resident);
    return true;
  } catch (error) {
    return false;
  }
};

const setToken = ({ access, refresh }) => {
  try {
    localStorage.setItem('access-token', access);
    localStorage.setItem('refresh-token', refresh);
    axios.defaults.headers.common.Authorization = access;
    return true;
  } catch (error) {
    return false;
  }
}

const clearUserData = () => {
  try {
    localStorage.removeItem('first_name');
    localStorage.removeItem('last_name');
    localStorage.removeItem('state_resident');
    localStorage.removeItem('email');
    localStorage.removeItem('access-token');
    localStorage.removeItem('refresh-token');
    return true;
  } catch (error) {
    return false;
  }
};

export const emailVerify = (token) =>
  axios.get(`${API_ENDPOINT_URL}/email-verify/?token=${token}`);

export const sendVerifyCode = () => {
  const token = localStorage.getItem('access-token');
  const email = localStorage.getItem('email');
  return axios.post(`${API_ENDPOINT_URL}/verification-code`, { email }, {
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
  }).then((res) => {
    if (res.data.email) {
      // setUserData({ email: res.data.email });
      setToken(res.data.tokens);
      return Promise.resolve({ success: true, data: res.data });
    }
    return Promise.resolve({ success: false, reason: res.data });
  })
    .catch((err) =>
      Promise.reject({ success: false, error: err.response.data }),
    );
}

export const validateVerifyCode = (code) => {
  const token = localStorage.getItem('access-token');
  const email = localStorage.getItem('email');
  return axios.post(`${API_ENDPOINT_URL}/validate-verification-code`, { verification_code: code, email }, {
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
  }).then((res) => {
    if (res.data.email) {
      // setUserData({ email: res.data.email });
      // setToken(res.data.tokens);
      return Promise.resolve({ success: true, data: res.data });
    }
  })
    .catch((err) =>
      Promise.reject({ success: false, error: err.response.data }),
    );
}

export default {
  login,
  register,
  loggedIn,
  getUserData,
  clearUserData,
  logout,
  emailVerify,
  sendVerifyCode,
};
