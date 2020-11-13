import React from 'react';
import { Button, Container, Grid, Icon } from 'semantic-ui-react';
import styled from 'styled-components';
import { PortalWrapper } from './style';
import loginBk from '../../assets/images/login-bk.png';
import logo from '../../assets/images/logo.png';
import GlobalStyle from '../../global-styles';
import CodeInput from '../../components/CodeInput';
import { validateVerifyCode } from '../../utils/api/auth';
import { withRouter } from 'react-router-dom';

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

class VerifyCode extends React.Component {
    state = {
        code: '',
        validationFailed: false,
    }

    handleCodeChange = (value) => {
        this.setState({ code: value })
    }

    handleVerify = () => {
        const { history } = this.props;
        const { code } = this.state;
        this.setState({ validationFailed: false })
        validateVerifyCode(code).then(res => {
            history.push('/');
        }).catch(e => this.setState({ validationFailed: true }))
    }

    render() {
        return (
            <Container style={{
                backgroundImage: `url(${loginBk})`,
                backgroundPosition: 'center',
                width: `100%`,
                height: `100vh`,
                padding: `20px`,
            }}>
                <Grid>
                    <Grid.Row textAlign="right">
                        <Grid.Column>
                            <img src={logo} />
                        </Grid.Column>
                    </Grid.Row>
                </Grid>
                <PortalWrapper>
                    <GlobalStyle></GlobalStyle>
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
                            {this.state.validationFailed && <Grid.Row textAlign="center">
                                <Grid.Column>
                                    <span style={{ color: 'red' }}>Incorrect Code</span>
                                </Grid.Column>
                            </Grid.Row>}
                            <Grid.Row>
                                <Grid.Column textAlign="right">
                                    <CodeContainer>
                                        <CodeInput onChange={this.handleCodeChange} />
                                    </CodeContainer>
                                </Grid.Column>
                            </Grid.Row>
                            <Grid.Row columns="2" verticalAlign="middle">
                                <Grid.Column textAlign="left">
                                    <span className="span-btn">
                                        <Icon name="redo alternate" /> Send a new code.
                      </span>
                                </Grid.Column>
                                <Grid.Column textAlign="right">
                                    <Button className="login" disabled={this.state.code.length !== 6} onClick={this.handleVerify}>
                                        Verify
                      </Button>
                                </Grid.Column>
                            </Grid.Row>
                        </Grid>
                    </Grid>
                </PortalWrapper>
            </Container>
        )
    }
}

export default withRouter(VerifyCode);