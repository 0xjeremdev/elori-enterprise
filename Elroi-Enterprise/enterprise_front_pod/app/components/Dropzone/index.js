import React, { useCallback } from "react";
import { useDropzone } from "react-dropzone";

function Dropzone(props) {
  const onDrop = useCallback((acceptedFiles) => {
    props.onDrop(acceptedFiles);
  }, []);

  const { acceptedFiles, getRootProps, getInputProps } = useDropzone({
    onDrop,
  });

  const files = acceptedFiles.map((file) => (
    <li key={file.path}>
      {file.path} - {file.size} bytes
    </li>
  ));

  return (
    <section className="container">
      <div {...getRootProps({ className: "dropzone" })}>
        <input {...getInputProps()} />
        <p className="desc-center">
          Please do NOT upload any document that is not required.
        </p>
        <p className="desc-center">Files larger than 4MB are not supported.</p>
      </div>
      <aside>
        <ul>{files}</ul>
      </aside>
    </section>
  );
}

export default Dropzone;
