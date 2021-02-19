import React from "react";
import { Button, Form, Modal } from "semantic-ui-react";

class AddUserModal extends React.Component {
  state = { email: "" };
  render() {
    return (
      <Modal dimmer={true} open={this.props.open} onClose={this.onClose}>
        <Modal.Header>Invite Enterprise User</Modal.Header>
        <Modal.Content>
          <Form>
            <Form.Input
              label="User Email"
              onChange={(e, { value }) => this.setState({ email: value })}
            />
          </Form>
        </Modal.Content>
        <Modal.Actions>
          <Button negative onClick={this.props.onClose}>
            Cancel
          </Button>
          <Button positive onClick={() => this.props.onInvite(this.state.email)}>
            OK
          </Button>
        </Modal.Actions>
      </Modal>
    );
  }
}

export default AddUserModal;
