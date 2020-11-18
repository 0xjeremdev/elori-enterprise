import axios from "axios";
import { API_ENDPOINT_URL } from "constants/defaults";

export const consumerRequestFormApis = {
  setConsumerRequestForm,
  getConsumerRequestForm,
  updateConsumerRequestForm,
};

function setConsumerRequestForm(payload) {
  const enterprise_id = localStorage.getItem("enterprise_id");
  const {
    logoFile,
    siteColor,
    siteTheme,
    backImg,
    companyName,
    lanchUrl,
    additionalQuestions,
  } = payload;
  const formData = new FormData();
  if (logoFile) {
    formData.append("logo", logoFile);
  }
  formData.append("site_color", JSON.stringify(siteColor));
  formData.append("site_theme", JSON.stringify(siteTheme));
  if (backImg) {
    formData.append("background_image", backImg);
  }
  formData.append("website_launched_to", lanchUrl);
  formData.append("company_name", companyName);
  formData.append(
    "additional_configuration",
    JSON.stringify(additionalQuestions)
  );
  formData.append("enterprise_id", enterprise_id);
  return new Promise((resolve, reject) => {
    axios
      .post(
        `${API_ENDPOINT_URL}/enterprise/consumer-request-config/`,
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

function updateConsumerRequestForm(payload) {
  const token = localStorage.getItem("access-token");
  const enterprise_id = localStorage.getItem("enterprise_id");
  const elroi_id = localStorage.getItem("elroi_id");
  const {
    logoFile,
    siteColor,
    siteTheme,
    backImg,
    companyName,
    lanchUrl,
    additionalQuestions,
  } = payload;
  const formData = new FormData();
  if (logoFile) {
    formData.append("logo", logoFile);
  }
  formData.append("site_color", JSON.stringify(siteColor));
  formData.append("site_theme", JSON.stringify(siteTheme));
  if (backImg) {
    formData.append("background_image", backImg);
  }
  formData.append("website_launched_to", lanchUrl);
  formData.append("company_name", companyName);
  formData.append(
    "additional_configuration",
    JSON.stringify(additionalQuestions)
  );
  formData.append("enterprise_id", enterprise_id);
  formData.append("elroi_id", elroi_id);
  return new Promise((resolve, reject) => {
    axios
      .put(
        `${API_ENDPOINT_URL}/enterprise/consumer-request-config/`,
        formData,
        {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        }
      )
      .then((res) => resolve(res))
      .catch((e) => reject(e));
  });
}

function getConsumerRequestForm(enterprise_id) {
  return new Promise((resolve, reject) => {
    axios
      .get(`${API_ENDPOINT_URL}/enterprise/consumer-request-config/${enterprise_id}`)
      .then((res) => {
        if (res.data.success) {
          resolve(res.data.data);
        }
      })
      .catch((e) => reject(e));
  });
}
