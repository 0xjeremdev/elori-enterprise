import React from "react";
import { Button, Form, Grid, Icon, Image, Input } from "semantic-ui-react";
import styled from "styled-components";
import noImage from "../../../../assets/images/no-img.png";

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

class UserSetting extends React.Component {
  render() {
    return (
      <Container>
        <Grid.Row verticalAlign="middle">
          <Grid.Column width={3}>
            <Image
              src={noImage}
              size="small"
              style={{ width: "120px", height: "120px" }}
              avatar
              bordered
              circular
            />
          </Grid.Column>
          <Grid.Column width={4}>
            <p>Change Profile Picture</p>
            <Button color="blue">
              <Icon name="upload" />
              Change Profile
            </Button>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column width={10}>
            <Grid>
              <Grid.Row columns={2}>
                <Grid.Column>
                  <Form>
                    <Form.Input label="First Name" />
                  </Form>
                </Grid.Column>
                <Grid.Column>
                  <Form>
                    <Form.Input label="Last Name" />
                  </Form>
                </Grid.Column>
              </Grid.Row>
              <Grid.Row>
                <Grid.Column>
                  <Form>
                    <Form.Input width={10} label="Company Email" />
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
                    <Form.Input label="Phone Number" />
                  </Form>
                </Grid.Column>
              </Grid.Row>
              <Grid.Row>
                <Grid.Column width={10}>
                  <Form>
                    <Form.Input label="Company Name" />
                  </Form>
                </Grid.Column>
                <Grid.Column width={6}>
                  <Form>
                    <Form.Dropdown selection options={[]} label="Timezone" />
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
            <Button size="large" color="blue">
              Save
            </Button>
          </Grid.Column>
        </Grid.Row>
      </Container>
    );
  }
}

export default UserSetting;
