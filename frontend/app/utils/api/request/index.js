import axios from "axios";
import { API_ENDPOINT_URL } from "../../../constants/defaults";

export const sendVerifyCode = (id) => {
  return axios
    .get(`${API_ENDPOINT_URL}/consumer/data-return/${id}`)
    .then((res) => {
      if (res.data.success) {
        return Promise.resolve({ success: true });
      }
      return Promise.resolve({ success: false });
    })
    .catch((err) =>
      Promise.reject({ success: false, error: err.response.data })
    );
};

export const validateVerifyCode = (id, code) => {
  return axios
    .post(`${API_ENDPOINT_URL}/consumer/data-return/${id}`, { code })
    .then((res) => {
      if (res.data.success) {
        return Promise.resolve({ success: true, data: res.data.data });
      }
      return Promise.resolve({ success: false });
    })
    .catch((err) =>
      Promise.reject({ success: false, error: err.response.data })
    );
};
