import React, { PureComponent } from "react";
import { withRouter } from "react-router-dom";
import { Sidebar, Menu, Grid, Icon, Image } from "semantic-ui-react";
import styled from "styled-components";
import noImage from "../../assets/images/no-img.png";
import auth from "../../utils/api/auth";

const MenuWithRef = React.forwardRef((props, ref) => <Menu {...props} />);

const SidebarWrap = styled(MenuWithRef)`
  height: 100vh !important;
  position: fixed !important;
  bottom: 0 !important;
  top: 0 !important;
  flex-direction: column;
  display: flex;
  box-shadow: none !important;
  overflow-x: hidden;
  width: 280px !important;
  background: #ffffff !important;
  border-top-right-radius: 50px !important;
`;

const MenuWrapper = styled.div`
  display: ${(props) => (props.visible ? "block" : "none !important")};
  width: 280px !important;
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  background: #fff;
  & .menu-item {
    cursor: pointer;
    background: #ffffff;
    & p {
      color: #008ffb;
      text-align: left;
      font-family: Poppins;
      font-size: 22px;
    }
  }
  & .menu-item.active {
    background: #e1e0ff;
    border-left: 6px solid #7e52e8 !important;
    & p {
      color: #0b7fd7;
      text-align: left;
      font-family: Poppins;
      font-size: 22px;
    }
  }
`;

// eslint-disable-next-line react/no-multi-comp
class VerticalSidebar extends PureComponent {
  logOut = () => {
    auth
      .logout()
      .then((res) => this.props.history.push("/login"))
      .catch((err) => this.props.history.push("/login"));
  };

  render() {
    const {
      animation,
      direction,
      visible,
      menu,
      onSelect,
      active,
    } = this.props;

    return (
      <Sidebar
        as={SidebarWrap}
        animation={animation}
        direction={direction}
        className="vertical-side-bar"
        icon="labeled"
        visible={visible}
        vertical
        width="wide"
      >
        <div
          style={{
            height: "calc(100% - 90px)",
            marginTop: "17px",
          }}
        >
          <div style={{ filter: "drop-shadow(1px 0px 2px white)" }}>
            <Image
              src={this.props.logoUrl ? this.props.logoUrl : noImage}
              size="tiny"
              centered
            />
          </div>
          <br />
          <MenuWrapper visible={visible}>
            {menu.map((item, id) => (
              <div
                key={`menu-${id}`}
                className={`menu-item ${
                  item.key === active.key ? "active" : ""
                }`}
                onClick={onSelect(item)}
              >
                <Menu.Item key={item.to}>
                  <p>{visible ? item.content : null}</p>
                </Menu.Item>
              </div>
            ))}
            <div key={`menu`} className={`menu-item`} onClick={this.logOut}>
              <Menu.Item>
                <p>Logout</p>
              </Menu.Item>
            </div>
          </MenuWrapper>
        </div>
      </Sidebar>
    );
  }
}

export default withRouter(VerticalSidebar);
