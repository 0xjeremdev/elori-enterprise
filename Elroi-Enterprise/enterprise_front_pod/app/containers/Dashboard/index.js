import React from "react";
import styled from "styled-components";
import { Route, Switch } from "react-router-dom";
import { Segment, Sidebar } from "semantic-ui-react";
import GlobalStyle from "../../global-styles";
import { adminRoutes } from "../../constants/adminRoutes";
import VerticalSidebar from "../../components/VerticalSidebar";
import routes from "../../constants/routes.json";
import Setting from "./Setting";
import Topbar from "../../components/Topbar";
import ConsumerRequest from "./ConsumerRequest";
import ConsumerDetail from "./ConsumerDetail";

const AppWrapper = styled("div")`
  min-height: calc(100vh);
  & .pusher {
    margin-left: ${(props) =>
      props.visible ? "-70px !important" : "0px !important"};
  }
`;

const RightWrapper = styled(Segment)`
  height: calc(100vh);
  overflow: hidden;
  display: flex;
  position: relative;
  flex-direction: column;
  padding: 0 !important;
`;

const ContentWrapper = styled.div`
  width: ${(props) => (props.visible ? "calc(100% - 350px)" : "calc(100% )")};
  flex: 1;
  display: block;
  overflow-x: hidden;
  overflow-y: auto;
  background: #ebebeb;
`;

class Dashboard extends React.Component {
  state = {
    animation: "push",
    direction: "left",
    dimmed: false,
    visible: true,
    contactBox: false,
    activeMenuItem: {
      key: "dashboard",
      to: routes.DASHBOARD,
      content: "Dashboard",
    },
  };

  componentDidUpdate(prevProps) {
    if (this.props.location !== prevProps.location) {
      window.scrollTo(0, 0);
    }
  }

  setActiveMenu = (item) => {
    if (item.to === routes.DASHBOARD) {
      this.setState({
        activeMenuItem: adminRoutes.filter(
          (item) => item.to === routes.DASHBOARD
        )[0],
      });
    } else if (item.to === routes.CONSUMER) {
      this.setState({
        activeMenuItem: adminRoutes.filter(
          (item) => item.to === routes.CONSUMER
        )[0],
      });
    }else if (item.to === routes.SETTING) {
      this.setState({
        activeMenuItem: adminRoutes.filter(
          (item) => item.to === routes.SETTING
        )[0],
      });
    }
  };

  componentDidMount() {
    this.setActiveMenu(this.state.activeMenuItem);
  }

  handleAnimationChange = (animation) => () =>
    this.setState((prevState) => ({ animation, visible: !prevState.visible }));

  selectMenu = (item) => () => {
    const { history } = this.props;
    history.push(item.to);
    this.setActiveMenu(item);
  };

  render() {
    const { animation, direction, visible, activeMenuItem } = this.state;
    return (
      <AppWrapper visible={visible}>
        <GlobalStyle />
        <Sidebar.Pushable as={Segment} style={{ marginTop: "0px" }}>
          <VerticalSidebar
            menu={adminRoutes}
            animation={animation}
            direction={direction}
            visible={visible}
            onSelect={this.selectMenu}
            onLogout={this.handleLogout}
            active={activeMenuItem}
            handleContact={this.handleContactAdmin}
          />
          <Sidebar.Pusher>
            <RightWrapper basic>
              <ContentWrapper
                fluid
                style={{ marginRight: "0 !important" }}
                visible={visible}
              >
                <Topbar />
                <Switch>
                  <Route exact path={routes.CONSUMER} component={ConsumerRequest} />
                  <Route exact path={routes.CONSUMERDETAIL} component={ConsumerDetail} />
                  <Route exact path={routes.SETTING} component={Setting} />
                </Switch>
              </ContentWrapper>
            </RightWrapper>
          </Sidebar.Pusher>
        </Sidebar.Pushable>
      </AppWrapper>
    );
  }
}

export default Dashboard;
