import React from "react";
import { Button, Form, Grid, Icon, Image } from "semantic-ui-react";
import styled from "styled-components";
import noImage from "../../../../assets/images/no-img.png";
import ColorPicker from "../../../../components/ColorPicker";

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
`;

class AccountSetting extends React.Component {
  state = {
    siteColor: { r: 150, g: 255, b: 10, a: 1 },
    secondColor: { r: 150, g: 255, b: 10, a: 1 },
  };

  setSiteColor = (siteColor) => {
    this.setState({ siteColor });
  };

  setSecondColor = (secondColor) => {
    this.setState({ secondColor });
  };

  render() {
    return (
      <Container>
        <Grid.Row verticalAlign="middle">
          <Grid.Column width={3}>
            <Image src={noImage} size="small" bordered />
          </Grid.Column>
          <Grid.Column width={4}>
            <p>Upload Logo</p>
            <Button color="blue">
              <Icon name="upload" />
              Upload
            </Button>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
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
        </Grid.Row>
        <Grid.Row>
          <Grid.Column>
            <Form>
              <Form.Input label="Company Email for Notification" width={6} />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row verticalAlign="middle">
          <Grid.Column width={2}>
            <label>
              <b>Add Users</b>
            </label>
          </Grid.Column>
          <Grid.Column width={4}>
            <Button color="blue">
              <Icon name="plus" /> Add User
            </Button>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column width={6}>
            <Form>
              <Form.Input label="Company Name" />
            </Form>
          </Grid.Column>
          <Grid.Column width={4}>
            <Form>
              <Form.Input label="Address" />
            </Form>
          </Grid.Column>
          <Grid.Column width={3}>
            <Form>
              <Form.Dropdown selection options={[]} label="Timezone" />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row textAlign="right">
          <Grid.Column>
            <Button size="large" color="yellow">
              Cancel
            </Button>
            <Button size="large" color="blue">
              Save
            </Button>
          </Grid.Column>
        </Grid.Row>
      </Container>
    );
  }
}

export default AccountSetting;
