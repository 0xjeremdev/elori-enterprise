import React from "react";
import styled from "styled-components";
import { Form, Grid, Button } from "semantic-ui-react";
import { emailApis } from "../../../../utils/api/setting/email";

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
  state = {
    emailTypes: [],
    activeEmail: {},
    activeEmailType: null,
  };

  componentDidMount() {
    emailApis.getEmailTypes().then((res) => this.setState({ emailTypes: res }));
  }

  selectEmailType = (type) => {
    emailApis
      .getEmailContent(type)
      .then((res) =>
        this.setState({ activeEmailType: type, activeEmail: res })
      );
  };

  handleSave = () => {
    
  }

  render() {
    const { emailTypes, activeEmail } = this.state;
    const emailCampaignOptions = emailTypes.map((type) => ({
      key: type.email_id,
      value: type.email_id,
      text: type.email_type,
    }));
    return (
      <Container>
        <Grid.Row>
          <Grid.Column>
            <Form>
              <Form.Dropdown
                selection
                options={emailCampaignOptions}
                label="Email Type"
                onChange={(e, { value }) => this.selectEmailType(value)}
              />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column>
            <Form>
              <Form.TextArea
                label="Email Content"
                rows={10}
                content={activeEmail.content || ""}
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
      </Container>
    );
  }
}

export default EmailCampaign;
