import { add } from "lodash";
import React from "react";
import { Button, Form, Grid, Icon, Image } from "semantic-ui-react";
import styled from "styled-components";
import noImage from "../../../../assets/images/no-img.png";
import ColorPicker from "../../../../components/ColorPicker";
import { timeframeOptions, timezoneOptions } from "../../../../constants/types";
import { enterpriseSettingApis } from "../../../../utils/api/setting/enterprise";
import AddUserModal from "./AddUserModal";

const Container = styled(Grid)`
  label,
  .ui.form label {
    color: #959494;
    margin-left: 10px;
  }
  .ui.form input,
  .ui.form .dropdown {
    border-radius: 20px !important;
  }
  & .upload-button {
    border-radius: 20px;
    padding: 7px 25px;
    background-color: #5fa1fc;
    color: white !important;
    box-shadow: 0px 3px 6px #0000005a;
    cursor: pointer;
  }
`;

class AccountSetting extends React.Component {
  state = {
    logoUrl: "",
    logoFile: null,
    logoFileName: "",
    logoBS64: null,
    siteColor: { r: 150, g: 255, b: 10, a: 1 },
    secondColor: { r: 150, g: 255, b: 10, a: 1 },
    notificationEmail: "",
    companyName: "",
    address: "",
    timezone: "",
    time_frame: "",
    addUserModal: false,
  };

  componentDidMount() {
    enterpriseSettingApis
      .getEnterpriseSetting()
      .then((res) => this.initState(res))
      .catch((err) => console.log("err", err));
  }

  initState = ({
    logo,
    site_color,
    second_color,
    notification_email,
    address,
    company_name,
    timezone,
    time_frame,
  }) => {
    this.props.logoUpdate(logo);
    this.setState({
      logoUrl: logo,
      siteColor: site_color,
      secondColor: second_color,
      notificationEmail:
        notification_email === "null" ? null : notification_email,
      address: address === "null" ? null : address,
      companyName: companyName === "null" ? null : companyName,
      timezone,
      time_frame,
    });
  };

  setSiteColor = (siteColor) => {
    this.setState({ siteColor });
  };

  setSecondColor = (secondColor) => {
    this.setState({ secondColor });
  };

  onLogoChange = (e) => {
    const self = this;
    console.log(e.target.files[0], " this is logo file");
    this.setState(
      { logoFile: e.target.files[0], logoFileName: e.target.files[0].name },
      () => {
        var fr = new FileReader();
        fr.onload = function() {
          self.setState({ logoBS64: fr.result });
        };
        fr.readAsDataURL(this.state.logoFile);
      }
    );
  };

  handleSave = () => {
    enterpriseSettingApis
      .setEnterpriseSetting(this.state)
      .then((res) => this.initState(res.data));
  };

  onInvite = (email) => {
    this.setState({ addUserModal: false });
    enterpriseSettingApis.sendUserInvite(email).then((res) => console.log(res));
  };

  render() {
    const { logoFile, logoUrl, logoBS64 } = this.state;
    return (
      <Container>
        <Grid.Row verticalAlign="middle">
          <Grid.Column width={3}>
            <Image
              src={logoFile ? logoBS64 : logoUrl}
              style={{ width: "120px", height: "120px" }}
              size="small"
              bordered
            />
          </Grid.Column>
          <Grid.Column width={4}>
            <input
              type="file"
              id="logo"
              accept="image/x-png,image/jpg,image/jpeg"
              hidden
              onChange={this.onLogoChange}
            />
            <p>Upload Logo</p>
            <label htmlFor="logo" className="upload-button">
              <Icon name="upload" />
              Upload
            </label>
          </Grid.Column>
        </Grid.Row>
        {/* <Grid.Row>
          <Grid.Column width={8}>
            <Grid>
              <Grid.Row columns={2} verticalAlign="middle">
                <Grid.Column>
                  <label>
                    <b>Site Color</b>
                  </label>
                </Grid.Column>
                <Grid.Column>
                  <ColorPicker
                    setColor={this.setSiteColor}
                    color={this.state.siteColor}
                  />
                </Grid.Column>
              </Grid.Row>
            </Grid>
          </Grid.Column>
          <Grid.Column width={8}>
            <Grid>
              <Grid.Row columns={2} verticalAlign="middle">
                <Grid.Column>
                  <label>
                    <b>Secondary Color</b>
                  </label>
                </Grid.Column>
                <Grid.Column>
                  <ColorPicker
                    setColor={this.setSecondColor}
                    color={this.state.secondColor}
                  />
                </Grid.Column>
              </Grid.Row>
            </Grid>
          </Grid.Column>
        </Grid.Row> */}
        <Grid.Row>
          <Grid.Column>
            <Form>
              <Form.Input
                label="Company Email for Notification"
                width={6}
                value={this.state.notificationEmail || ""}
                onChange={(e, { value }) =>
                  this.setState({ notificationEmail: value })
                }
              />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row verticalAlign="middle">
          {/*<Grid.Column width={2}>
            <label>
              <b>Add Users</b>
            </label>
          </Grid.Column>
           <Grid.Column width={4}>
            <Button
              color="blue"
              onClick={() => this.setState({ addUserModal: true })}
            >
              <Icon name="plus" /> Add User
            </Button>
          </Grid.Column> */}
        </Grid.Row>
        <Grid.Row>
          <Grid.Column width={6}>
            <Form>
              <Form.Input
                label="Company Name"
                value={this.state.companyName || ""}
                onChange={(e, { value }) =>
                  this.setState({ companyName: value })
                }
              />
            </Form>
          </Grid.Column>
          <Grid.Column width={4}>
            <Form>
              <Form.Input
                label="Address"
                value={this.state.address || ""}
                onChange={(e, { value }) => this.setState({ address: value })}
              />
            </Form>
          </Grid.Column>
          <Grid.Column width={3}>
            <Form>
              <Form.Dropdown
                selection
                options={timezoneOptions}
                label="Timezone"
                value={this.state.timezone || ""}
                onChange={(e, { value }) => this.setState({ timezone: value })}
              />
            </Form>
          </Grid.Column>
          <Grid.Column width={3}>
            <Form>
              <Form.Dropdown
                selection
                options={timeframeOptions}
                label="Timeframe"
                value={this.state.time_frame || ""}
                onChange={(e, { value }) =>
                  this.setState({ time_frame: value })
                }
              />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row textAlign="right">
          <Grid.Column>
            <Button size="large" color="yellow">
              Cancel
            </Button>
            <Button size="large" color="blue" onClick={() => this.handleSave()}>
              Save
            </Button>
          </Grid.Column>
        </Grid.Row>
        <AddUserModal
          open={this.state.addUserModal}
          onInvite={this.onInvite}
          onClose={() => this.setState({ addUserModal: false })}
        />
      </Container>
    );
  }
}

export default AccountSetting;
