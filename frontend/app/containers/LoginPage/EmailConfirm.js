import React from "react";
import { withRouter } from "react-router-dom";
import { Button, Container, Dimmer, Header, Loader } from "semantic-ui-react";
import styled from "styled-components";
import loginBk from "../../assets/images/login-bk.png";
import { emailVerify } from "../../utils/api/auth";

const Wrapper = styled.div`
  .ui.button {
    border-radius: 20px;
    background: linear-gradient(135deg, #fec871, #feb172);
    width: 160px;
    height: 40px;
    margin-right: 18px;
    color: #ffffff;
  }
`;

class EmailConfirm extends React.Component {
  state = {
    confirming: true,
    msg: "",
  };

  goToLogin = () => {
    const { history } = this.props;
    history.push(`/login`);
  };

  componentDidMount = () => {
    const { id } = this.props.match.params;
    emailVerify(id)
      .then((res) => {
        this.setState({ confirming: false, msg: res.data.email });
      })
      .catch((error) => {
        this.setState({ confirming: false, msg: error.response.data.error });
      });
  };

  render() {
    const { confirming } = this.state;
    return (
      <Container
        style={{
          backgroundImage: `url(${loginBk})`,
          backgroundPosition: "center",
          width: `100%`,
          height: `100vh`,
          padding: `20px`,
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
        }}
      >
        {confirming && (
          <Dimmer active>
            <Loader size="medium" />
          </Dimmer>
        )}
        {!confirming && (
          <Wrapper style={{ textAlign: "center" }}>
            <Header textAlign="center">{this.state.msg}</Header>
            <Button onClick={this.goToLogin}>Login</Button>
          </Wrapper>
        )}
      </Container>
    );
  }
}

export default withRouter(EmailConfirm);
