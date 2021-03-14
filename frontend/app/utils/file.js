export const blobToFile = (theBlob, fileName) => {
  theBlob.lastModifiedDate = new Date();
  theBlob.name = fileName;
  return theBlob;
};

export const blobFileToNewTab = (file) => {
  const byteCharacters = atob(file.content);
  const byteNumbers = new Array(byteCharacters.length);
  for (let i = 0; i < byteCharacters.length; i++) {
    byteNumbers[i] = byteCharacters.charCodeAt(i);
  }
  const byteArray = new Uint8Array(byteNumbers);
  const fileObj = new Blob([byteArray], {
    type: file.type,
  });
  const fileURL = URL.createObjectURL(fileObj);
  window.open(fileURL);
};

export const baseToImgSrc = (file) => {
  if(file) {
    return `data:${file.type};base64,${file.content}`;
  }
  return null;
};
