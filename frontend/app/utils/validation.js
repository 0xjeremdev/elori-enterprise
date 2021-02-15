export const isEmailValid = (email) => {
  return new RegExp(/[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,15}/g).test(email);
};

export const getFileExtenstion = (fileName) => {
  return fileName.split(".")[fileName.split(".").length - 1];
};

export const getFileSizeMb = (byteSize) => {
  return parseFloat(byteSize / 1000000);
};
