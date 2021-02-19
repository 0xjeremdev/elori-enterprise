import React from "react";
import { withRouter } from "react-router-dom";
import { Button, Container, Grid, Icon, Input } from "semantic-ui-react";
import { connect } from "react-redux";
import GlobalStyle from "../../global-styles";
import { signUpRequest } from "../../redux/actions/auth";
import { isEmailValid } from "../../utils/validation";
import logo from "../../assets/images/logo.png";
import loginBk from "../../assets/images/login-bk.png";
import { PortalWrapper } from "./style";

class Signup extends React.Component {
  state = {
    signProcess: false,
    newUserEmail: "",
    newUserName: "",
    newUserFName: "",
    newUserLName: "",
    newUserPwd: "",
    newUserConfirmPwd: "",
    togglePwd: false,
    toggleConfirmPwd: false,
  };

  isSignUpUserValid = () => {
    const {
      newUserEmail,
      newUserFName,
      newUserName,
      newUserLName,
      newUserPwd,
      newUserConfirmPwd,
    } = this.state;
    if (
      newUserEmail !== "" &&
      newUserName !== "" &&
      newUserFName !== "" &&
      newUserLName !== "" &&
      newUserPwd !== "" &&
      newUserConfirmPwd == newUserPwd
    ) {
      if (isEmailValid(newUserEmail)) {
        return true;
      }
    }
    return false;
  };

  handleSignRequest = () => {
    const { dispatch } = this.props;
    const {
      newUserEmail,
      newUserName,
      newUserFName,
      newUserLName,
      newUserPwd,
    } = this.state;
    // this.setState({ sendSignRequst: true });
    if (this.isSignUpUserValid()) {
      dispatch(
        signUpRequest({
          newUserEmail,
          newUserName,
          newUserFName,
          newUserLName,
          newUserPwd,
        })
      );
    }
  };

  togglePwd = (type) => {
    if (type) {
      this.setState({ toggleConfirmPwd: !this.state.toggleConfirmPwd });
    } else {
      this.setState({ togglePwd: !this.state.togglePwd });
    }
  };

  goToLogin = () => {
    const { history } = this.props;
    history.push("/login");
  };

  render() {
    const { auth } = this.props;

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
        <GlobalStyle />
        <Grid>
          <Grid.Row textAlign="right">
            <Grid.Column>
              <img src={logo} alt="No Img"/>
            </Grid.Column>
          </Grid.Row>
        </Grid>
        <PortalWrapper>
          <Grid verticalAlign="middle">
            <Grid.Row>
              {!auth.sentSignupRequest && (
                <Grid>
                  <Grid.Row>
                    <Grid.Column>
                      <span className="title">Create Your Account</span>
                    </Grid.Column>
                  </Grid.Row>
                  {auth.signupError &&
                    Object.keys(auth.signupError).map((key) => (
                      <span key={key} className="error-msg">
                        {key}: {auth.signupError[key]}
                      </span>
                    ))}
                  <Grid.Row>
                    <Grid.Column>
                      <span className="input-label">E-Mail</span>
                      <Input
                        icon="mail outline"
                        iconPosition="left"
                        type="email"
                        value={this.state.newUserEmail}
                        onChange={(e, { value }) =>
                          this.setState({ newUserEmail: value })
                        }
                      />
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row>
                    <Grid.Column>
                      <span className="input-label">Username</span>
                      <Input
                        icon="user"
                        iconPosition="left"
                        value={this.state.newUserName}
                        onChange={(e, { value }) =>
                          this.setState({ newUserName: value })
                        }
                      />
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row>
                    <Grid.Column>
                      <span className="input-label">First Name</span>
                      <Input
                        icon="user"
                        iconPosition="left"
                        value={this.state.newUserFName}
                        onChange={(e, { value }) =>
                          this.setState({ newUserFName: value })
                        }
                      />
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row>
                    <Grid.Column>
                      <span className="input-label">Last Name</span>
                      <Input
                        icon="user"
                        iconPosition="left"
                        value={this.state.newUserLName}
                        onChange={(e, { value }) =>
                          this.setState({ newUserLName: value })
                        }
                      />
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row>
                    <Grid.Column>
                      <span className="input-label">Password</span>
                      <Input
                        icon
                        iconPosition="left right"
                        value={this.state.newUserPwd}
                        onChange={(e, { value }) =>
                          this.setState({ newUserPwd: value })
                        }
                      >
                        <Icon name="key" />
                        <input
                          type={this.state.togglePwd ? "text" : "password"}
                        />
                        <Icon
                          name="eye"
                          link
                          onClick={() => this.togglePwd(0)}
                        />
                      </Input>
                    </Grid.Column>
                  </Grid.Row>
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
                          type={
                            this.state.toggleConfirmPwd ? "text" : "password"
                          }
                        />
                        <Icon
                          name="eye"
                          link
                          onClick={() => this.togglePwd(1)}
                        />
                      </Input>
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row columns={2} verticalAlign="middle">
                    <Grid.Column textAlign="left">
                      <span className="span-btn" onClick={this.goToLogin}>
                        Already have account?
                      </span>
                    </Grid.Column>
                    <Grid.Column textAlign="right">
                      <Button
                        className="login"
                        onClick={this.handleSignRequest}
                        loading={auth.currentlySendingSignup}
                        disabled={!this.isSignUpUserValid()}
                      >
                        Sign Up
                      </Button>
                    </Grid.Column>
                  </Grid.Row>
                </Grid>
              )}
              {auth.sentSignupRequest && (
                <Grid textAlign="center">
                  <Grid.Row>
                    <Grid.Column>
                      <span className="title">Please verify your email</span>
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row>
                    <Grid.Column>
                      <span>
                        You're almost there! We sent an email to{" "}
                        <b>{this.state.newUserEmail}</b>
                      </span>
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row>
                    <Grid.Column>
                      <Button className="login" onClick={this.handleResend}>
                        Resend Email
                      </Button>
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row textAlign="center">
                    <Grid.Column>
                      <span>Need help?</span>
                      <span className="number span-btn"> Contact Us</span>
                    </Grid.Column>
                  </Grid.Row>
                </Grid>
              )}
            </Grid.Row>
          </Grid>
        </PortalWrapper>
      </Container>
    );
  }
}

export default withRouter(connect(({ auth }) => ({ auth }))(Signup));
