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
import { accountSettingApis } from "../../utils/api/setting/account";
import { enterpriseSettingApis } from "../../utils/api/setting/enterprise";
import NotFound from "../NotFound";
import { ToastProvider } from "react-toast-notifications";
import { baseToImgSrc } from "../../utils/file";

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
      key: "consumer",
      to: routes.CONSUMER,
      content: "Consumer Request",
    },
    avatarUrl: null,
    logoUrl: null,
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
    } else if (item.to === routes.SETTING) {
      this.setState({
        activeMenuItem: adminRoutes.filter(
          (item) => item.to === routes.SETTING
        )[0],
      });
    } else if (item.to === routes.PRIVACY) {
      this.setState({
        activeMenuItem: adminRoutes.filter(
          (item) => item.to === routes.PRIVACY
        )[0],
      });
    } else if (item.to === routes.REGISTER) {
      this.setState({
        activeMenuItem: adminRoutes.filter(
          (item) => item.to === routes.REGISTER
        )[0],
      });
    } else if (item.to === routes.DISPOSAL) {
      this.setState({
        activeMenuItem: adminRoutes.filter(
          (item) => item.to === routes.DISPOSAL
        )[0],
      });
    } else if (item.to === routes.USERS) {
      this.setState({
        activeMenuItem: adminRoutes.filter(
          (item) => item.to === routes.USERS
        )[0],
      });
    } else if (item.to === routes.RESOURCES) {
      this.setState({
        activeMenuItem: adminRoutes.filter(
          (item) => item.to === routes.RESOURCES
        )[0],
      });
    }
  };

  componentDidMount() {
    this.setActiveMenu(this.state.activeMenuItem);
    accountSettingApis.getAccountSetting().then(({ logo }) => {
      this.updateAvatar(logo);
    });
    enterpriseSettingApis.getEnterpriseSetting().then(({ logo_data }) => {
      this.logoUpdate(baseToImgSrc(logo_data));
    });
  }

  handleAnimationChange = (animation) => () =>
    this.setState((prevState) => ({ animation, visible: !prevState.visible }));

  selectMenu = (item) => () => {
    const { history } = this.props;
    history.push(item.to);
    this.setActiveMenu(item);
  };

  updateAvatar = (avatarUrl) => {
    this.setState({ avatarUrl });
  };

  logoUpdate = (logoUrl) => {
    this.setState({ logoUrl });
  };

  render() {
    const { animation, direction, visible, activeMenuItem } = this.state;
    return (
      <AppWrapper visible={visible}>
        <ToastProvider placement="top-right">
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
              logoUrl={this.state.logoUrl}
            />
            <Sidebar.Pusher>
              <RightWrapper basic>
                <ContentWrapper
                  fluid
                  style={{ marginRight: "0 !important" }}
                  visible={visible}
                >
                  <Topbar avatarUrl={this.state.avatarUrl} />
                  <Switch>
                    <Route
                      exact
                      path={routes.CONSUMER}
                      component={ConsumerRequest}
                    />
                    <Route
                      exact
                      path={routes.CONSUMERDETAIL}
                      component={ConsumerDetail}
                    />
                    <Route
                      exact
                      path={routes.SETTING}
                      render={(props) => (
                        <Setting
                          {...props}
                          onAvatarUpdate={this.updateAvatar}
                          onlogoUpdate={this.logoUpdate}
                        />
                      )}
                    />
                    <Route component={NotFound} />
                  </Switch>
                </ContentWrapper>
              </RightWrapper>
            </Sidebar.Pusher>
          </Sidebar.Pushable>
        </ToastProvider>
      </AppWrapper>
    );
  }
}

export default Dashboard;
