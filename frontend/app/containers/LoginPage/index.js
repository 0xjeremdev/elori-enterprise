import React from "react";
import { withRouter } from "react-router-dom";
import {
  Button,
  Checkbox,
  Container,
  Grid,
  Icon,
  Input,
} from "semantic-ui-react";
import { connect } from "react-redux";
import styled from "styled-components";
import GlobalStyle from "../../global-styles";
import logo from "../../assets/images/logo.png";
import loginBk from "../../assets/images/login-bk.png";
import { PortalWrapper } from "./style";
import { loginRequest } from "../../redux/actions/auth";

const PrivacyBtn = styled.span`
  cursor: pointer;
  color: #6b6c6f;
`;

class Login extends React.Component {
  state = {
    email: "",
    password: "",
    togglePwd: false,
  };

  handleLogin = () => {
    const { dispatch } = this.props;
    const { email, password } = this.state;
    if (email !== "" && password !== "") {
      dispatch(loginRequest({ email, password }));
    }
  };

  handleSignup = () => {
    const { history } = this.props;
    history.push("/signup");
  };
  handleResend = () => {};

  togglePwd = () => {
    this.setState({ togglePwd: !this.state.togglePwd });
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
        <Grid>
          <Grid.Row textAlign="right">
            <Grid.Column>
              <img src={logo} alt="No Img"/>
            </Grid.Column>
          </Grid.Row>
        </Grid>
        <PortalWrapper>
          <GlobalStyle />
          <Grid verticalAlign="middle">
            <Grid.Row>
              <Grid.Column>
                <Grid>
                  <Grid.Row>
                    <Grid.Column>
                      <span className="title">Log In to Your Account</span>
                    </Grid.Column>
                  </Grid.Row>
                  {auth.loginError &&
                    Object.keys(auth.loginError).map((key) => (
                      <span key={key} className="error-msg">
                        {key}: {auth.loginError[key]}
                      </span>
                    ))}
                  <Grid.Row>
                    <Grid.Column>
                      <span className="input-label">E-Mail</span>
                      <Input
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
                  <Grid.Row>
                    <Grid.Column>
                      <span className="input-label">Password</span>
                      <Input
                        icon
                        iconPosition="left right"
                        placeholder="Your Password"
                        value={this.state.password}
                        onChange={(e, { value }) =>
                          this.setState({ password: value })
                        }
                      >
                        <Icon name="key" />
                        <input
                          type={this.state.togglePwd ? "text" : "password"}
                        />
                        <Icon
                          name="eye"
                          link
                          onClick={() => this.togglePwd()}
                        />
                      </Input>
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row columns="2">
                    <Grid.Column textAlign="left">
                      <Button
                        className="login"
                        onClick={this.handleLogin}
                        loading={auth.currentlySending}
                      >
                        Login
                      </Button>
                    </Grid.Column>
                    <Grid.Column textAlign="right">
                      <Button className="login" onClick={this.handleSignup}>
                        Sign Up
                      </Button>
                    </Grid.Column>
                  </Grid.Row>
                  <Grid.Row columns={2}>
                    <Grid.Column>
                      <Checkbox className="remember-me" label="Remember Me" />
                    </Grid.Column>
                    <Grid.Column>
                      <span className="span-btn">Forgot Password?</span>
                    </Grid.Column>
                  </Grid.Row>
                </Grid>
              </Grid.Column>
            </Grid.Row>
          </Grid>
        </PortalWrapper>
        <Grid style={{ padding: "100px 50px" }}>
          <Grid.Row>
            <Grid.Column verticalAlign="bottom">
              <PrivacyBtn>&bull; Privacy</PrivacyBtn>
            </Grid.Column>
          </Grid.Row>
        </Grid>
      </Container>
    );
  }
}

export default withRouter(connect(({ auth }) => ({ auth }))(Login));
