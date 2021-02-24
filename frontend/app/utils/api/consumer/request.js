import axios from "axios";
import "../index";
import { API_ENDPOINT_URL } from "constants/defaults";

export const consumerRequestApis = {
  sendConsumerRequest,
  getConsumerRequest,
  updateConsumerRequest,
  sendProcessingEmail,
};

function sendConsumerRequest(payload, web_id) {
  const {
    first_name,
    last_name,
    email,
    request_type,
    file,
    additional_fields,
    country,
    state,
    timeframe,
  } = payload;
  const formData = new FormData();
  if (file) {
    formData.append("file", file);
  }
  formData.append("first_name", first_name);
  formData.append("last_name", last_name);
  formData.append("email", email);
  formData.append("state_resident", JSON.stringify({ country, state }));
  formData.append("request_type", request_type);
  formData.append("web_id", web_id);
  formData.append("timeframe", timeframe);
  formData.append("additional_fields", JSON.stringify(additional_fields));
  return new Promise((resolve, reject) => {
    axios
      .post(`${API_ENDPOINT_URL}/consumer/request`, formData, {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      })
      .then((res) => resolve(res))
      .catch((e) => reject(e));
  });
}

function sendProcessingEmail({ id, file, email_type }) {
  const token = localStorage.getItem("access-token");
  const formData = new FormData();
  formData.append("attachment", file);
  formData.append("id", id);
  formData.append("email_type", email_type);
  return new Promise((resolve, reject) => {
    axios
      .post(`${API_ENDPOINT_URL}/consumer/request/send`, formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "multipart/form-data",
        },
      })
      .then((res) => resolve(res))
      .catch((e) => reject(e));
  });
}

function getConsumerRequest() {
  const token = localStorage.getItem("access-token");
  const enterprise_id = localStorage.getItem("enterprise_id");
  return new Promise((resolve, reject) => {
    axios
      .get(`${API_ENDPOINT_URL}/consumer/request/${enterprise_id}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((res) => resolve(res.data))
      .catch((e) => reject(e));
  });
}

function updateConsumerRequest({ id, status, extend, comment }) {
  const token = localStorage.getItem("access-token");
  return new Promise((resolve, reject) => {
    axios
      .post(
        `${API_ENDPOINT_URL}/consumer/set-status`,
        {
          id,
          status: status ? status : undefined,
          extended: extend,
          comment: comment ? comment : undefined,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      )
      .then((res) => resolve(res.data))
      .catch((e) => reject(e));
  });
}
