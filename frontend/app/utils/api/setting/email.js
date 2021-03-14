import axios from "axios";
import "../index";

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

function updateEmail(type, content, attachment) {
  const token = localStorage.getItem("access-token");
  const formData = new FormData();
  if (attachment) {
    formData.append("attachment", attachment);
  }
  formData.append("content", content);
  return new Promise((resolve, reject) => {
    axios
      .post(`${API_ENDPOINT_URL}/enterprise/email/${type}`, formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "multipart/form-data",
        },
      })
      .then((res) => resolve(res.data))
      .catch((e) => reject(e));
  });
}
