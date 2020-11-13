import axios from "axios";
import { API_ENDPOINT_URL } from "constants/defaults";

export const consumerRequestApis = {
  sendConsumerRequest,
};

function sendConsumerRequest(payload) {
  const token = localStorage.getItem("access-token");
  const enterprise_id = localStorage.getItem("enterprise_id");
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
  formData.append("enterprise", enterprise_id);
  formData.append("additional_fields", JSON.stringify(additional_fields));
  return new Promise((resolve, reject) => {
    axios
      .post(`${API_ENDPOINT_URL}/consumer/request`, formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "multipart/form-data",
        },
      })
      .then((res) => resolve(res))
      .catch((e) => reject(e));
  });
}
