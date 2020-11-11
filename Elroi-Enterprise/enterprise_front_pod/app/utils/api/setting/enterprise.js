import axios from "axios";
import { API_ENDPOINT_URL } from "constants/defaults";

export const enterpriseSettingApis = {
  getEnterpriseSetting,
  setEnterpriseSetting,
};

function setEnterpriseSetting(payload) {
  const token = localStorage.getItem("access-token");
  const {
    logoFile,
    siteColor,
    secondColor,
    notificationEmail,
    companyName,
    address,
    timezone,
  } = payload;
  const formData = new FormData();
  if(logoFile) {
      formData.append("logo", logoFile);
  }
  formData.append("site_color", JSON.stringify(siteColor));
  formData.append("second_color", JSON.stringify(secondColor));
  formData.append("notification_email", notificationEmail);
  formData.append("company_name", companyName);
  formData.append("address", address);
  formData.append("timezone", timezone);
  return new Promise((resolve, reject) => {
    axios
      .post(
        `${API_ENDPOINT_URL}/enterprise/settings`,
        formData,
        {
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "multipart/form-data",
          },
        }
      )
      .then((res) => resolve(res))
      .catch((e) => reject(e));
  });
}

function getEnterpriseSetting() {
    const token = localStorage.getItem("access-token");
    return new Promise((resolve, reject) => {
      axios
        .get(`${API_ENDPOINT_URL}/enterprise/settings`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        })
        .then((res) => resolve(res.data))
        .catch((e) => reject(e));
    });
  }
