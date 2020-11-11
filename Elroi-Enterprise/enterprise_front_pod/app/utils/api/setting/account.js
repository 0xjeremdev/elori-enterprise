import axios from "axios";
import { API_ENDPOINT_URL } from "constants/defaults";

export const accountSettingApis = {
  setAccountSetting,
  getAccountSetting,
};

function setAccountSetting(payload) {
  const token = localStorage.getItem("access-token");
  const {
    logoFile,
    phoneNumber,
    companyEmail,
    companyName,
    firstName,
    lastName,
    timezone,
  } = payload;
  const formData = new FormData();
  if (logoFile) {
    formData.append("logo", logoFile);
  }
  formData.append("phone_number", phoneNumber);
  formData.append("company_email", companyEmail);
  formData.append("company_name", companyName);
  formData.append("first_name", firstName);
  formData.append("last_name", lastName);
  formData.append("timezone", timezone);
  return new Promise((resolve, reject) => {
    axios
      .post(`${API_ENDPOINT_URL}/profile-settings/`, formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "multipart/form-data",
        },
      })
      .then((res) => resolve(res))
      .catch((e) => reject(e));
  });
}

function getAccountSetting() {
  const token = localStorage.getItem("access-token");
  return new Promise((resolve, reject) => {
    axios
      .get(`${API_ENDPOINT_URL}/profile-settings/`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then((res) => resolve(res.data))
      .catch((e) => reject(e));
  });
}
