import React, { useCallback } from "react";
import { useDropzone } from "react-dropzone";
import { Button } from "semantic-ui-react";

function Dropzone(props) {
  const onDrop = useCallback((acceptedFiles) => {
    props.onDrop(acceptedFiles);
  }, []);

  const { acceptedFiles, getRootProps, open, getInputProps } = useDropzone({
    onDrop,
    noClick: true,
    noKeyboard: true,
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
        <Button color="blue" onClick={open}>
          Open File Dialog
        </Button>
      </div>
      <aside>
        <ul>{files}</ul>
      </aside>
    </section>
  );
}

export default Dropzone;
