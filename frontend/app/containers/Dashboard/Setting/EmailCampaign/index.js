import React from "react";
import styled from "styled-components";
import { Form, Grid, Button, Input } from "semantic-ui-react";
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
  & .upload-button {
    border-radius: 20px;
    padding: 7px 25px;
    background-color: #5fa1fc;
    color: white !important;
    box-shadow: 0px 3px 6px #0000005a;
    cursor: pointer;
  }
  padding-bottom: 30px !important;
`;

class EmailCampaign extends React.Component {
  state = {
    emailTypes: [],
    activeEmail: {},
    activeEmailType: null,
    selectFile: null,
    sentSaveRequest: false,
  };

  componentDidMount() {
    emailApis.getEmailTypes().then((res) => this.setState({ emailTypes: res }));
  }

  selectEmailType = (type) => {
    emailApis.getEmailContent(type).then((res) =>
      this.setState({
        activeEmailType: type,
        activeEmail: { content: res.content, attachment: res.attachment },
      })
    );
  };

  onFileChange = (e) => {
    this.setState({
      selectFile: e.target.files[0],
      activeEmail: {
        ...this.state.activeEmail,
        attachment: e.target.files[0].name,
      },
    });
  };

  handleSave = () => {
    const { activeEmail, activeEmailType, selectFile } = this.state;
    this.setState({ sentSaveRequest: true });
    emailApis
      .updateEmail(activeEmailType, activeEmail.content, selectFile)
      .then((res) => this.setState({ sentSaveRequest: false }));
  };

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
                value={activeEmail.content || ""}
                onChange={(e, { value }) =>
                  this.setState({
                    activeEmail: { ...this.state.activeEmail, content: value },
                  })
                }
              />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row verticalAlign="middle">
          <Grid.Column width={4}>
            <label>
              <b>File Attachment</b>
            </label>
            <br />
            <Input value={activeEmail.attachment || ""} />
            <input
              type="file"
              id="fileAttach"
              hidden
              onChange={this.onFileChange}
            />
          </Grid.Column>
          <Grid.Column width={12}>
            <br />
            <label htmlFor="fileAttach" className="upload-button">
              Choose File
            </label>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row textAlign="right">
          <Grid.Column>
            <Button size="large" color="yellow">
              Cancel
            </Button>
            <Button
              size="large"
              color="blue"
              onClick={() => this.handleSave()}
              loading={this.state.sentSaveRequest}
            >
              Save
            </Button>
          </Grid.Column>
        </Grid.Row>
      </Container>
    );
  }
}

export default EmailCampaign;
