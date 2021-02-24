import axios from "axios";

(function ApiInit() {
  const token = localStorage.getItem("access-token");
  if (token) {
    axios.defaults.headers.common.Authorization = token;
  } else {
    axios.defaults.headers.common.Authorization = null;
  }

  axios.interceptors.response.use(
    (response) => response,
    (error) => {
      if (error.response.status === 401) {
        if (token) {
          // eslint-disable-next-line no-undef
          swal({
            title: 'Session Expired',
            text:
              'Your session has expired. Would you like to be redirected to the login page?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#DD6B55',
            confirmButtonText: 'Yes',
            closeOnConfirm: false,
          }).then(() => {
            localStorage.clear();
            window.location = '/login';
          });
        }
        return Promise.reject(error);
      }
      return Promise.reject(error);
    }
  );
})();
