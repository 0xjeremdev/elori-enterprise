import axios from "axios";
import { API_ENDPOINT_URL } from "constants/defaults";

export const emailApis = {
  getEmailTypes,
  getEmailContent,
  updateEmail,
};

function getEmailTypes() {
  const token = localStorage.getItem("access-token");
  return new Promise((resolve, reject) => {
    axios
      .get(`${API_ENDPOINT_URL}/enterprise/email/type`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((res) => resolve(res.data))
      .catch((e) => reject(e));
  });
}

function getEmailContent(type) {
  const token = localStorage.getItem("access-token");
  return new Promise((resolve, reject) => {
    axios
      .get(`${API_ENDPOINT_URL}/enterprise/email/${type}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((res) => resolve(res.data))
      .catch((e) => reject(e));
  });
}

function updateEmail(type, data) {
  const token = localStorage.getItem("access-token");
  return new Promise((resolve, reject) => {
    axios
      .post(`${API_ENDPOINT_URL}/enterprise/email/${type}`, data, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((res) => resolve(res.data))
      .catch((e) => reject(e));
  });
}
