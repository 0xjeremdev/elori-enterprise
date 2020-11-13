import React from "react";
import { Button, Form, Grid, Icon, Image, Input } from "semantic-ui-react";
import styled from "styled-components";
import noImage from "../../../../assets/images/no-img.png";
import { timezoneOptions } from "../../../../constants/types";
import { accountSettingApis } from "../../../../utils/api/setting/account";

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

class UserSetting extends React.Component {
  state = {
    logoUrl: "",
    logoFile: null,
    logoFileName: "",
    logoBS64: null,
    phoneNumber: "",
    companyEmail: "",
    companyName: "",
    firstName: "",
    lastName: "",
    timezone: "",
  };

  initState = ({
    logo,
    first_name,
    last_name,
    company_email,
    phone_number,
    company_name,
    timezone,
  }) => {
    this.props.avatarUpdate(logo);
    this.setState({
      logoUrl: logo,
      firstName: first_name,
      lastName: last_name,
      companyEmail: company_email,
      phoneNumber: phone_number,
      companyName: company_name,
      timezone,
    });
  };

  componentDidMount() {
    accountSettingApis.getAccountSetting().then((res) => this.initState(res));
  }

  onLogoChange = (e) => {
    const self = this;
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
    accountSettingApis
      .setAccountSetting(this.state)
      .then((res) => this.initState(res.data));
  };

  render() {
    const { logoFile, logoUrl, logoBS64 } = this.state;

    return (
      <Container>
        <Grid.Row verticalAlign="middle">
          <Grid.Column width={3}>
            <Image
              src={logoFile ? logoBS64 : logoUrl}
              size="small"
              style={{ width: "120px", height: "120px" }}
              avatar
              bordered
              circular
            />
          </Grid.Column>
          <Grid.Column width={4}>
            <input type="file" id="logo" hidden onChange={this.onLogoChange} />
            <p>Change Profile Picture</p>
            <label htmlFor="logo" className="upload-button">
              <Icon name="upload" />
              Change Profile
            </label>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column width={10}>
            <Grid>
              <Grid.Row columns={2}>
                <Grid.Column>
                  <Form>
                    <Form.Input
                      label="First Name"
                      onChange={(e, { value }) =>
                        this.setState({ firstName: value })
                      }
                      value={this.state.firstName || ""}
                    />
                  </Form>
                </Grid.Column>
                <Grid.Column>
                  <Form>
                    <Form.Input
                      label="Last Name"
                      onChange={(e, { value }) =>
                        this.setState({ lastName: value })
                      }
                      value={this.state.lastName || ""}
                    />
                  </Form>
                </Grid.Column>
              </Grid.Row>
              <Grid.Row>
                <Grid.Column>
                  <Form>
                    <Form.Input
                      width={10}
                      label="Company Email"
                      onChange={(e, { value }) =>
                        this.setState({ companyEmail: value })
                      }
                      value={this.state.companyEmail || ""}
                    />
                  </Form>
                </Grid.Column>
              </Grid.Row>
              <Grid.Row verticalAlign="middle">
                <Grid.Column width={10}>
                  <Form>
                    <Form.Input label="New Password" />
                  </Form>
                </Grid.Column>
                <Grid.Column width={6}>
                  <Form>
                    <br />
                    <Form.Button color="blue">Reset</Form.Button>
                  </Form>
                </Grid.Column>
              </Grid.Row>
              <Grid.Row>
                <Grid.Column>
                  <Form>
                    <Form.Input
                      label="Phone Number"
                      onChange={(e, { value }) =>
                        this.setState({ phoneNumber: value })
                      }
                      value={this.state.phoneNumber || ""}
                    />
                  </Form>
                </Grid.Column>
              </Grid.Row>
              <Grid.Row>
                <Grid.Column width={10}>
                  <Form>
                    <Form.Input
                      label="Company Name"
                      onChange={(e, { value }) =>
                        this.setState({ companyName: value })
                      }
                      value={this.state.companyName || ""}
                    />
                  </Form>
                </Grid.Column>
                <Grid.Column width={6}>
                  <Form>
                    <Form.Dropdown
                      selection
                      options={timezoneOptions}
                      label="Timezone"
                      value={this.state.timezone || ""}
                      onChange={(e, { value }) =>
                        this.setState({ timezone: value })
                      }
                    />
                  </Form>
                </Grid.Column>
              </Grid.Row>
            </Grid>
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
      </Container>
    );
  }
}

export default UserSetting;
