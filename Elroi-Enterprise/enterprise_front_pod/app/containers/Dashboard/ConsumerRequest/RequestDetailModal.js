import { map } from "lodash";
import React from "react";
import { Button, Grid, Modal } from "semantic-ui-react";
import styled from "styled-components";
import { COMPLETE, PROCESS, REJECT } from "../../../constants/constants";
const Container = styled.div`
  & span {
    color: #707683 !important;
  }
`;

class RequestDetailModal extends React.Component {
  render() {
    const { data } = this.props;
    return (
      <Container>
        <Modal dimmer={true} open={this.props.open} onClose={this.onClose}>
          <Modal.Header>Consumer Requst Detail</Modal.Header>
          <Modal.Content>
            <Grid>
              <Grid.Row columns={2}>
                <Grid.Column>
                  <span>ID: {data.id}</span>
                </Grid.Column>
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
                {map(data.additional_fields, (item) => (
                  <Grid.Column key={item.question}>
                    {item.question}:{item.value}
                  </Grid.Column>
                ))}
                <Grid.Column>
                  <a href={data.file} target="_blank">
                    Review File
                  </a>
                </Grid.Column>
              </Grid.Row>
              <Grid.Row columns={1}>
                <Grid.Column textAlign="right">
                  <Button basic color="yellow" onClick={()=>this.props.onUpdate(data.id, null, true)}>
                    Extend
                  </Button>
                  <Button basic color="red" onClick={()=>this.props.onUpdate(data.id, REJECT, false)}>
                    Reject
                  </Button>
                  <Button basic color="blue" onClick={()=>this.props.onUpdate(data.id, PROCESS, false)}>
                    Approve
                  </Button>
                  <Button basic color="teal" onClick={()=>this.props.onUpdate(data.id, COMPLETE, false)}>
                    Complete
                  </Button>
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
