import axios from "axios";
import { API_ENDPOINT_URL } from "constants/defaults";

export const consumerReportApis = {
  downloadConsumerReport,
};

function downloadConsumerReport({
  start_date,
  end_date,
  report_type,
  timeframe,
  status,
}) {
  const token = localStorage.getItem("access-token");
  const enterprise_id = localStorage.getItem("enterprise_id");
  return new Promise((resolve, reject) => {
    axios
      .get(
        `${API_ENDPOINT_URL}/consumer/report/${enterprise_id}?start_date=${start_date}&end_date=${end_date}&report_type=${report_type}&timeframe=${timeframe}&status=${status}`,
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
