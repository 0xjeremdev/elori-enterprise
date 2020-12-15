import React from "react";
import { withRouter } from "react-router-dom";
import { Button, Container, Dimmer, Header, Loader } from "semantic-ui-react";
import styled from "styled-components";
import loginBk from "../../assets/images/login-bk.png";
import { customerVerify } from "../../utils/api/auth";

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

class StaffConfirm extends React.Component {
  state = {
    confirming: true,
    msg: "",
    enterprise: {},
  };

  goToLogin = () => {
    const { history } = this.props;
    history.push(`/signup`);
  };

  componentDidMount = () => {
    const { id } = this.props.match.params;
    console.log("this is invite id", id);
    customerVerify(id)
      .then((res) => {
        console.log(res);
        this.setState(
          {
            confirming: false,
            msg: `You are verified with ${res.data.email}`,
            enterprise: res.data.enterprise,
          },
          () => {
            localStorage.setItem(
              "enterprise_elroi_id",
              this.state.enterprise && this.state.enterprise.elroi_id
            );
          }
        );
      })
      .catch((error) => {
        console.log(error.response.data);
        this.setState({ confirming: false, msg: "Failed" });
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
            <Button onClick={this.goToLogin}>SignUp</Button>
          </Wrapper>
        )}
      </Container>
    );
  }
}

export default withRouter(StaffConfirm);
