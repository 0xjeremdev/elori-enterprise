import React from "react";
import { Button, Container, Grid, Input } from "semantic-ui-react";

import loginBk from "../../assets/images/login-bk.png";
import logo from "../../assets/images/logo.png";
import GlobalStyle from "../../global-styles";
import { sendPasswordReset } from "../../utils/api/auth";
import { isEmailValid } from "../../utils/validation";
import { PortalWrapper } from "./style";

class ResetPassword extends React.Component {
  state = {
    email: "",
    invalid: "",
    msg: "",
    currentlySending: false,
    requestSuccess: false,
  };

  handleReset = () => {
    const { email } = this.state;
    if (isEmailValid(email)) {
      this.setState({ msg: "", currentlySending: true });
      sendPasswordReset(email).then((res) => {
        if (res.success) {
          this.setState({
            requestSuccess: true,
            msg: res.msg,
            currentlySending: false,
          });
        } else {
          this.setState({
            requestSuccess: false,
            msg: res.msg,
            currentlySending: false,
          });
        }
      });
    } else {
      this.setState({ msg: "Email is invalid" });
    }
  };

  render() {
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
            {this.state.requestSuccess && (
              <Grid verticalAlign="middle">
                <Grid.Row>
                  <p>{this.state.msg}</p>
                </Grid.Row>
                <Grid.Row columns="2">
                  <Grid.Column />
                  <Grid.Column textAlign="right">
                    <Button
                      className="login"
                      onClick={this.handleReset}
                      loading={this.state.currentlySending}
                    >
                      Resend
                    </Button>
                  </Grid.Column>
                </Grid.Row>
              </Grid>
            )}
            {!this.state.requestSuccess && (
              <Grid verticalAlign="middle">
                <Grid.Row>
                  <Grid.Column>
                    <span className="input-label">Enter your E-Mail</span>
                    {this.state.msg && (
                      <span className="error-msg">{this.state.msg}</span>
                    )}
                    <Input
                      type="email"
                      icon="mail outline"
                      iconPosition="left"
                      placeholder="Your E-Mail"
                      value={this.state.email}
                      onChange={(e, { value }) =>
                        this.setState({ email: value })
                      }
                    />
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row columns="2">
                  <Grid.Column />
                  <Grid.Column textAlign="right">
                    <Button
                      className="login"
                      onClick={this.handleReset}
                      loading={this.state.currentlySending}
                    >
                      Reset
                    </Button>
                  </Grid.Column>
                </Grid.Row>
              </Grid>
            )}
          </PortalWrapper>
        </Grid>
      </Container>
    );
  }
}

export default ResetPassword;
