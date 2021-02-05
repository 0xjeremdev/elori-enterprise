import React from "react";
import { Button, Modal } from "semantic-ui-react";

class ConfirmModal extends React.Component {
  render() {
    return (
      <Modal dimmer={true} open={this.props.open} onClose={this.onClose}>
        <Modal.Header>Your request has been sent successfully.</Modal.Header>
        <Modal.Content>Please check your email about details.</Modal.Content>
        <Modal.Actions>
          <Button positive onClick={this.props.onClose}>
            OK
          </Button>
        </Modal.Actions>
      </Modal>
    );
  }
}

export default ConfirmModal;
