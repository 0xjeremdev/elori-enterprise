import React from "react";
import { Button, Grid, Progress } from "semantic-ui-react";
import styled from "styled-components";
import {
  COMPLETE,
  PROCESS,
  REJECT,
  REVIEW,
} from "../../../constants/constants";

const Container = styled.div`
  border-radius: 4px;
  background: #ffffff;
  box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  .title {
    font-size: 20px;
    color: #39a5d1;
  }
  p,
  .span-grey {
    color: #4c5862;
  }
  .span-black {
    color: #334d6e;
  }
`;

class RequestItem extends React.Component {
  calcRemainingDate = (request_date) => {
    const today = new Date();
    const receiveDate = new Date(request_date);
    const diffTime = Math.abs(today - receiveDate);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) - 1;
    return diffDays;
  };

  render() {
    const { data } = this.props;

    return (
      <Container>
        <Grid>
          <Grid.Row>
            <Grid.Column width={4} verticalAlign="middle" textAlign="center">
              <div>
                <span className="title">
                  {data.first_name} {data.last_name}
                </span>
              </div>
            </Grid.Column>
            <Grid.Column width={8} verticalAlign="middle">
              <Grid>
                <Grid.Row>
                  <Grid.Column width={8}>
                    <p className="span-grey">Requested Timestamp</p>
                    <p className="span-grey">Approved Timestamp</p>
                  </Grid.Column>
                  <Grid.Column width={8}>
                    <p className="span-black">
                      {new Date(data.request_date).toLocaleDateString()}
                    </p>
                    <p className="span-black">
                      {data.approved_date ? data.approved_date : "-"}
                    </p>
                  </Grid.Column>
                </Grid.Row>
              </Grid>
            </Grid.Column>
            <Grid.Column width={4} textAlign="center">
              <Grid>
                <Grid.Row>
                  <Grid.Column>
                    <span className="span-grey">ID: {data.id}</span>
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <Button
                      color={
                        data.status === REVIEW
                          ? "olive"
                          : data.status === PROCESS
                          ? "yellow"
                          : data.status === COMPLETE
                          ? "blue"
                          : "red"
                      }
                    >
                      {data.status === COMPLETE && "Complete"}
                      {data.status === REJECT && "Rejected"}
                      {data.status === PROCESS && "Processing"}
                      {data.status === REVIEW && "Review"}
                    </Button>
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <span className="span-grey">
                      Days Left to Process:{" "}
                      {this.calcRemainingDate(data.process_end_date)}
                    </span>
                  </Grid.Column>
                </Grid.Row>
              </Grid>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row style={{ padding: "0px" }}>
            <Grid.Column>
              <Progress
                percent={
                  ((45 - this.calcRemainingDate(data.request_date)) / 45) * 100
                }
                success={this.props.status === "success"}
                error={this.props.status === "error"}
                warning={this.props.status === "warning"}
                size="tiny"
              />
            </Grid.Column>
          </Grid.Row>
        </Grid>
      </Container>
    );
  }
}

export default RequestItem;
