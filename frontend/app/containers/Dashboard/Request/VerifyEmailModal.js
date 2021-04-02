import React from "react";
import { Button, Container, Grid, Icon, Modal } from "semantic-ui-react";
import styled from "styled-components";
import CodeInput from "../../../components/CodeInput";
import { consumerRequestApis } from "../../../utils/api/consumer/request";
import { PortalWrapper } from "../../LoginPage/style";

const CodeContainer = styled.div`
  display: flex;
  flex-direction: row;
  align-items: spaces-between;
  padding: 15px 0px;
  justify-content: center;
  & input:focus {
    outline-color: #2fbaff;
  }
`;

class VerifyEmailModal extends React.Component {
  state = {
    code: "",
    validationFailed: false,
  };

  handleCodeChange = (value) => {
    this.setState({ code: value });
  };

  handleVerify = () => {
    const { web_id, email } = this.props;
    const { code } = this.state;
    this.setState({ validationFailed: false });
    consumerRequestApis
      .validateOneCodeEmail(web_id, email, code)
      .then((res) => {
        this.props.onVerifySuccess();
        this.props.onClose();
      })
      .catch((e) => {
        this.setState({ validationFailed: true });
      });
  };

  sendCode = () => {
    const { web_id, email } = this.props;
    consumerRequestApis
      .sendOneCodeEmail(web_id, email)
      .then((res) => console.log(res));
  };

  render() {
    return (
      <Modal
        dimmer={true}
        style={{ width: "500px" }}
        open={this.props.open}
        onClose={this.props.onClose}
      >
        <PortalWrapper>
          <Grid verticalAlign="middle">
            <Grid>
              <Grid.Row textAlign="center">
                <Grid.Column>
                  <span className="title">
                    Enter the code to verify this device
                  </span>
                </Grid.Column>
              </Grid.Row>
              <Grid.Row textAlign="center">
                <Grid.Column>
                  <span>A temporary verification code to your email</span>
                </Grid.Column>
              </Grid.Row>
              {this.state.validationFailed && (
                <Grid.Row textAlign="center">
                  <Grid.Column>
                    <span style={{ color: "red" }}>Incorrect Code</span>
                  </Grid.Column>
                </Grid.Row>
              )}
              <Grid.Row>
                <Grid.Column textAlign="right">
                  <CodeContainer>
                    <CodeInput onChange={this.handleCodeChange} />
                  </CodeContainer>
                </Grid.Column>
              </Grid.Row>
              <Grid.Row columns="2" verticalAlign="middle">
                <Grid.Column textAlign="left">
                  <span className="span-btn" onClick={() => this.sendCode()}>
                    <Icon name="redo alternate" /> Send a new code.
                  </span>
                </Grid.Column>
                <Grid.Column textAlign="right">
                  <Button
                    className="login"
                    disabled={this.state.code.length !== 6}
                    onClick={this.handleVerify}
                  >
                    Verify
                  </Button>
                </Grid.Column>
              </Grid.Row>
            </Grid>
          </Grid>
        </PortalWrapper>
      </Modal>
    );
  }
}

export default VerifyEmailModal;
