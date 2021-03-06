import React from "react";
import { Button, Container, Grid, Icon } from "semantic-ui-react";
import styled from "styled-components";
import { PortalWrapper } from "./style";
import loginBk from "../../assets/images/login-bk.png";
import logo from "../../assets/images/logo.png";
import GlobalStyle from "../../global-styles";
import CodeInput from "../../components/CodeInput";
import { sendVerifyCode, validateVerifyCode } from "../../utils/api/request";
import { withRouter } from "react-router-dom";
import { blobFileToNewTab } from "../../utils/file";
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
class VerifyGetData extends React.Component {
  state = {
    code: "",
    validationFailed: false,
    isValid: false,
    tokenInvalid: false,
  };
  componentDidMount() {
    const { id } = this.props.match.params;
    sendVerifyCode(id)
      .then((res) => {
        if (res.success) {
          this.setState({ tokenInvalid: false });
        } else {
          this.setState({ tokenInvalid: true });
        }
      })
      .catch((e) => this.setState({ tokenInvalid: true }));
  }
  handleCodeChange = (value) => {
    this.setState({ code: value });
  };
  handleVerify = () => {
    const { id } = this.props.match.params;
    const { code } = this.state;
    this.setState({ validationFailed: false });
    validateVerifyCode(id, code)
      .then((res) => {
        if (res.success) {
          this.setState({ isValid: true });
          blobFileToNewTab(res.data);
        }
      })
      .catch((e) => this.setState({ validationFailed: true }));
  };
  render() {
    const { isValid, tokenInvalid } = this.state;
    return (
      <Container
        style={{
          backgroundImage: `url(${loginBk})`,
          backgroundPosition: "center",
          width: `100%`,
          height: `100vh`,
          padding: `20px`,
        }}
      >
        <Grid>
          <Grid.Row textAlign="right">
            <Grid.Column>
              <img src={logo} alt="No Img" />
            </Grid.Column>
          </Grid.Row>
        </Grid>
        <GlobalStyle />
        {!tokenInvalid && (
          <PortalWrapper>
            {!isValid && (
              <Grid verticalAlign="middle">
                <Grid>
                  <Grid.Row textAlign="center">
                    <Grid.Column>
                      <span className="title">
                        Enter the code to download data
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
                    <Grid.Column textAlign="left" />
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
            )}
            {isValid && (
              <Grid>
                <Grid.Row textAlign="center">
                  <Grid.Column>
                    <span className="title">Your code is valid.</span>
                  </Grid.Column>
                </Grid.Row>
              </Grid>
            )}
          </PortalWrapper>
        )}
        {tokenInvalid && (
          <PortalWrapper>
            <Grid>
              <Grid.Row textAlign="center">
                <Grid.Column>
                  <span className="title">Token is expired or invalid.</span>
                </Grid.Column>
              </Grid.Row>
            </Grid>
          </PortalWrapper>
        )}
      </Container>
    );
  }
}
export default withRouter(VerifyGetData);
