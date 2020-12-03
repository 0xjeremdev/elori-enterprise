import axios from "axios";
import { API_ENDPOINT_URL } from "constants/defaults";

export const consumerRequestApis = {
  sendConsumerRequest,
  getConsumerRequest,
  updateConsumerRequest,
};

function sendConsumerRequest(payload, enterprise_id) {
  const {
    first_name,
    last_name,
    email,
    state_resident,
    request_type,
    file,
    additional_fields,
  } = payload;
  const formData = new FormData();
  if (file) {
    formData.append("file", file);
  }
  formData.append("first_name", first_name);
  formData.append("last_name", last_name);
  formData.append("email", email);
  formData.append("state_resident", state_resident);
  formData.append("request_type", request_type);
  formData.append("enterprise_id", enterprise_id);
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

function updateConsumerRequest(id, newStatus, extendStatus) {
  const token = localStorage.getItem("access-token");
  return new Promise((resolve, reject) => {
    axios
      .post(
        `${API_ENDPOINT_URL}/consumer/set-status`,
        {
          id,
          status: newStatus ? newStatus : undefined,
          extended: extendStatus,
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
