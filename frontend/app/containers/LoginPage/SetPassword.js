import React from "react";
import { withRouter } from "react-router-dom";
import { Button, Container, Grid, Icon, Input } from "semantic-ui-react";

import loginBk from "../../assets/images/login-bk.png";
import logo from "../../assets/images/logo.png";
import GlobalStyle from "../../global-styles";
import { resetPassword } from "../../utils/api/auth";
import { PortalWrapper } from "./style";

class SetPassword extends React.Component {
  state = {
    newUserPwd: "",
    newUserConfirmPwd: "",
    togglePwd: false,
    toggleConfirmPwd: false,
    msg: null,
  };

  togglePwd = (type) => {
    if (type) {
      this.setState({ toggleConfirmPwd: !this.state.toggleConfirmPwd });
    } else {
      this.setState({ togglePwd: !this.state.togglePwd });
    }
  };

  handleResetPwd = () => {
    const { uidb64, token } = this.props.match.params;
    const { newUserPwd, newUserConfirmPwd } = this.state;
    if (newUserPwd !== "" && newUserPwd === newUserConfirmPwd) {
      resetPassword(newUserPwd, token, uidb64)
        .then((res) => {
          if (res.success) {
            this.props.history.push("/login");
          } else {
            this.setState({ msg: res.msg });
          }
        })
        .catch((err) => console.error(err));
    }
  };

  render() {
    const { msg } = this.state;
    return (
      <Container
        style={{
          backgroundImage: `url(${loginBk})`,
          backgroundPosition: "center",
          width: `100%`,
          height: `100vh`,
          padding: `20px`,
          overflow: `auto`,
        }}
      >
        <Grid>
          <Grid.Row textAlign="right">
            <Grid.Column>
              <img src={logo} alt="No Img" />
            </Grid.Column>
          </Grid.Row>
          <PortalWrapper>
            <GlobalStyle />
            {msg &&
              Object.keys(msg).map((key) => (
                <p key={key} className="error-msg">
                  {msg[key]}
                </p>
              ))}
            <Grid.Row>
              <Grid.Column>
                <span className="input-label">New Password</span>
                <Input
                  icon
                  iconPosition="left right"
                  value={this.state.newUserPwd}
                  onChange={(e, { value }) =>
                    this.setState({ newUserPwd: value })
                  }
                >
                  <Icon name="key" />
                  <input type={this.state.togglePwd ? "text" : "password"} />
                  <Icon name="eye" link onClick={() => this.togglePwd(0)} />
                </Input>
              </Grid.Column>
            </Grid.Row>
            <br />
            {this.state.newUserConfirmPwd !== "" &&
              this.state.newUserConfirmPwd !== this.state.newUserPwd && (
                <span className="error-msg">Password does not match</span>
              )}
            <Grid.Row>
              <Grid.Column>
                <span className="input-label">Confirm Password</span>
                <Input
                  icon
                  iconPosition="left right"
                  value={this.state.newUserConfirmPwd}
                  onChange={(e, { value }) =>
                    this.setState({ newUserConfirmPwd: value })
                  }
                >
                  <Icon name="key" />
                  <input
                    type={this.state.toggleConfirmPwd ? "text" : "password"}
                  />
                  <Icon name="eye" link onClick={() => this.togglePwd(1)} />
                </Input>
              </Grid.Column>
            </Grid.Row>
            <br />
            <Grid.Row>
              <Grid.Column width="16">
                <Button className="login" onClick={this.handleResetPwd}>
                  Submit
                </Button>
              </Grid.Column>
            </Grid.Row>
          </PortalWrapper>
        </Grid>
      </Container>
    );
  }
}

export default withRouter(SetPassword);
