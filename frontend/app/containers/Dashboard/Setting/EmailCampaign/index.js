import React from "react";
import { Form, Grid, Button } from "semantic-ui-react";
import styled from "styled-components";
import { emailCampaignOptions } from "../../../../constants/types";

const Container = styled(Grid)`
  label,
  .ui.form label {
    color: #959494;
    margin-left: 10px;
  }
  .ui.form input,
  .ui.form .dropdown {
    font-size: 14px;
  }
  padding-bottom: 30px !important;
`;

class EmailCampaign extends React.Component {
  render() {
    return (
      <Container>
        <Grid.Row>
          <Grid.Column>
            <Form>
              <Form.Dropdown
                selection
                options={emailCampaignOptions}
                label="Email Type"
              />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column>
            <Form>
              <Form.TextArea label="Email Content" rows={10} />
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
      </Container>
    );
  }
}

export default EmailCampaign;
