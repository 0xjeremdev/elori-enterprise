import { map } from "lodash";
import React from "react";
import { Container, Tab } from "semantic-ui-react";
import styled from "styled-components";
import AccountSetting from "./AccountSetting";
import ConfigureRequest from "./ConfigureRequest";
import UserSetting from "./UserSetting";

const ContentContainer = styled(Container)`
  .ui.tabular.menu .item {
    font-size: 16px !important;
    color: #707070 !important;
    text-transform: uppercase;
  }

  .ui.tabular.menu {
    margin-top: 15px;
    margin-bottom: -2px;
  }
  .ui.tabular.menu .active.item {
    font-size: 16px !important;
    color: #00a7fa !important;
    text-transform: uppercase;
  }

  .ui.styled.accordion .title,
  .ui.styled.accordion .active .title {
    background: 0 0;
    color: #ff7f00 !important;
    font-weight: none !important;
  }

  .ui.styled.accordion {
    box-shadow: 3px 2px 4px #00000055 !important;
    border: 1px solid #959494;
    border-radius: 20px !important;
    margin-top: 20px;
  }

  .ui.bottom.attached.segment.active.tab {
    box-shadow: rgba(123, 123, 123, 0.34) 0px 2px 6px !important;
  }
  margin-bottom: 30px;
`;

class Setting extends React.Component {
  render() {
    const panes = [
      {
        menuItem: "Account Setting",
        render: () => (
          <Tab.Pane>
            <UserSetting />
          </Tab.Pane>
        ),
      },
      {
        menuItem: "Target Dashboard",
        render: () => (
          <Tab.Pane>
            <AccountSetting />
          </Tab.Pane>
        ),
      },
      {
        menuItem: "Configure Request Form",
        render: () => (
          <Tab.Pane>
            <ConfigureRequest />
          </Tab.Pane>
        ),
      },
    ];
    return (
      <ContentContainer>
        <Tab
          className="tabmenu"
          panes={map(panes, (item) => !!item.render && item)}
        />
      </ContentContainer>
    );
  }
}

export default Setting;
