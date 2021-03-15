import { map } from "lodash";
import React from "react";
import {
  Button,
  Divider,
  Form,
  Grid,
  Input,
  Modal,
  Popup,
} from "semantic-ui-react";
import styled from "styled-components";
import {
  COMPLETE,
  PROCESS,
  REJECT,
  REVIEW,
} from "../../../constants/constants";
import { consumerRequestApis } from "../../../utils/api/consumer/request";
import { emailApis } from "../../../utils/api/setting/email";
import { blobFileToNewTab } from "../../../utils/file";
import { getFileExtenstion } from "../../../utils/validation";
const Container = styled.div`
  & span {
    color: #707683 !important;
  }
  label.attach-button {
    border-radius: 20px;
    padding: 7px 25px;
    background-color: #5fa1fc;
    color: white !important;
    box-shadow: 0px 3px 6px #0000005a;
    cursor: pointer;
  }
  label,
  .ui.form label {
    color: #959494;
    margin-left: 10px;
  }
`;

const ConfirmContainer = styled.div`
  margin: 3px 5px;
  width: 245px;
  color: #959494;
  font-weight: bold;
  text-align: right;
`;

class RequestDetailModal extends React.Component {
  state = {
    processFile: {},
    emailTypes: [],
    selectedEmailType: "",
    selectFile: null,
    completeDisable: true,
    sendEmail: false,
  };

  componentDidMount() {
    emailApis.getEmailTypes().then((res) => this.setState({ emailTypes: res }));
  }

  componentDidUpdate(prevPros) {
    const { open } = this.props;
    if (!prevPros.open && open) {
      this.initState();
    }
  }

  initState = () => {
    this.setState({
      processFile: {},
      selectedEmailType: "",
      selectFile: null,
      completeDisable: true,
      sendEmail: false,
    });
  };

  handleSend = (id) => {
    const { selectedEmailType, selectFile } = this.state;
    this.setState({ sendEmail: true });
    consumerRequestApis
      .sendProcessingEmail({
        id,
        email_type: selectedEmailType,
        file: selectFile,
      })
      .then((res) =>
        this.setState({ completeDisable: false, sendEmail: false })
      );
  };

  onFileChange = (e) => {
    const fExtension = getFileExtenstion(e.target.files[0].name);
    if (fExtension === "pdf") {
      this.setState({
        selectFile: e.target.files[0],
        processFile: {
          ...this.state.processFile,
          attachment: e.target.files[0].name,
        },
      });
    } else {
      alert("Documents should be pdf");
    }
  };

  render() {
    const { data } = this.props;
    const { emailTypes, processFile, completeDisable, sendEmail } = this.state;
    const emailCampaignOptions = emailTypes.map((type) => ({
      key: type.email_id,
      value: type.type_name,
      text: type.email_type,
    }));

    return (
      <Container>
        <Modal dimmer={true} open={this.props.open} onClose={this.onClose}>
          <Modal.Header>Consumer Request Detail</Modal.Header>
          <Modal.Content>
            <Grid>
              <Grid.Row columns={2}>
                <Grid.Column>
                  <span>ID: {data.id}</span>
                </Grid.Column>
                <Grid.Column>
                  <span>
                    Country:{" "}
                    {data.state_resident && data.state_resident.country}
                  </span>
                </Grid.Column>
                {data.state_resident &&
                  data.state_resident.country ===
                    "United States of America" && (
                    <Grid.Column>
                      <span>
                        State:{" "}
                        {data.state_resident && data.state_resident.state}
                      </span>
                    </Grid.Column>
                  )}
                <Grid.Column>
                  <span>
                    Full Name: {data.first_name} {data.last_name}
                  </span>
                </Grid.Column>
                <Grid.Column>
                  <span>Email: {data.email}</span>
                </Grid.Column>
                <Grid.Column>
                  <span>Request Type: {data.request_type}</span>
                </Grid.Column>
                <Grid.Column>
                  <span>Status: {data.status_text}</span>
                </Grid.Column>
                {map(
                  data.additional_fields,
                  (item) =>
                    item.value && (
                      <Grid.Column key={item.question}>
                        {item.question}:{item.value}
                      </Grid.Column>
                    )
                )}
                {data.file && (
                  <Grid.Column>
                    <a
                      target="_blank"
                      onClick={() => {
                        blobFileToNewTab(data.file);
                      }}
                    >
                      Review File
                    </a>
                  </Grid.Column>
                )}
              </Grid.Row>
              <Divider />
              {data.status === PROCESS && (
                <Grid.Row>
                  <Grid.Column width={8}>
                    <Container>
                      <Form>
                        <Form.Dropdown
                          selection
                          options={emailCampaignOptions}
                          label="Email Type"
                          onChange={(e, { value }) =>
                            this.setState({ selectedEmailType: value })
                          }
                        />
                      </Form>
                    </Container>
                  </Grid.Column>
                  <Grid.Column width={7}>
                    <Container>
                      <label>
                        <b>File Attachment</b>
                      </label>
                      <br />
                      <Input value={processFile.attachment || ""} />
                      <input
                        type="file"
                        id="fileAttachForm"
                        hidden
                        accept="application/pdf"
                        onChange={this.onFileChange}
                      />
                      <label htmlFor="fileAttachForm" className="attach-button">
                        Choose File
                      </label>
                    </Container>
                  </Grid.Column>
                </Grid.Row>
              )}
              <Grid.Row columns={1}>
                <Grid.Column textAlign="right">
                  {data.status === PROCESS && (
                    <Popup
                      trigger={
                        <Button
                          basic
                          color="yellow"
                          disabled={data.is_extended}
                        >
                          Extend
                        </Button>
                      }
                      on="click"
                    >
                      <ConfirmContainer>
                        <Grid.Row>
                          <h3>Are you sure to update status?</h3>
                          <br />
                        </Grid.Row>
                        <Grid.Row>
                          <Grid.Column>
                            <Button.Group>
                              <Button>Cancel</Button>
                              <Button.Or />
                              <Button
                                positive
                                onClick={() =>
                                  this.props.onUpdate(data.id, null, true)
                                }
                              >
                                Confirm
                              </Button>
                            </Button.Group>
                          </Grid.Column>
                        </Grid.Row>
                      </ConfirmContainer>
                    </Popup>
                  )}
                  {data.status === REVIEW && (
                    <Button
                      basic
                      color="red"
                      onClick={() =>
                        this.props.onUpdate(data.id, REJECT, false)
                      }
                    >
                      Reject
                    </Button>
                  )}
                  {data.status === REVIEW && (
                    <Button
                      basic
                      color="blue"
                      onClick={() =>
                        this.props.onUpdate(data.id, PROCESS, false)
                      }
                    >
                      Approve
                    </Button>
                  )}
                  {data.status === PROCESS && (
                    <Button
                      basic
                      color="teal"
                      onClick={() => this.handleSend(data.id)}
                      loading={sendEmail}
                      disabled={!completeDisable}
                    >
                      {completeDisable ? "Send Email" : "Sent Email"}
                    </Button>
                  )}
                  {data.status === PROCESS && (
                    <Popup
                      trigger={
                        <Button basic color="teal" disabled={completeDisable}>
                          Complete
                        </Button>
                      }
                      on="click"
                    >
                      <ConfirmContainer>
                        <Grid.Row>
                          <h3>Are you sure to update status?</h3>
                          <br />
                        </Grid.Row>
                        <Grid.Row>
                          <Grid.Column>
                            <Button.Group>
                              <Button>Cancel</Button>
                              <Button.Or />
                              <Button
                                positive
                                onClick={() =>
                                  this.props.onUpdate(data.id, COMPLETE, false)
                                }
                              >
                                Confirm
                              </Button>
                            </Button.Group>
                          </Grid.Column>
                        </Grid.Row>
                      </ConfirmContainer>
                    </Popup>
                  )}
                </Grid.Column>
              </Grid.Row>
            </Grid>
          </Modal.Content>
          <Modal.Actions>
            <Button positive onClick={this.props.onClose}>
              Close
            </Button>
          </Modal.Actions>
        </Modal>
      </Container>
    );
  }
}

export default RequestDetailModal;
