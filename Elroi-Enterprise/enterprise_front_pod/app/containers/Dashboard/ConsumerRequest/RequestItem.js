import React from "react";
import { Button, Grid, Progress } from "semantic-ui-react";
import styled from "styled-components";

const Container = styled.div`
  border-radius: 4px;
  background: #ffffff;
  box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  p,
  .span-grey {
    color: #4c5862;
  }
  .span-black {
    color: #334d6e;
  }
`;

class RequestItem extends React.Component {
  render() {
    return (
      <Container>
        <Grid>
          <Grid.Row>
            <Grid.Column width={4} verticalAlign="middle" textAlign="center">
              <p>Data Subject Name</p>
              <Button positive attached="left">
                YES
              </Button>
              <Button negative attached="right">
                NO
              </Button>
            </Grid.Column>
            <Grid.Column width={8} verticalAlign="middle">
              <Grid>
                <Grid.Row>
                  <Grid.Column width={8}>
                    <p className="span-grey">Requested Timestamp</p>
                    <p className="span-grey">Approved Timestamp</p>
                  </Grid.Column>
                  <Grid.Column width={8}>
                    <p className="span-black">Oct 22, 2020</p>
                    <p className="span-black">Oct 22, 2020</p>
                  </Grid.Column>
                </Grid.Row>
              </Grid>
            </Grid.Column>
            <Grid.Column width={4} textAlign="center">
              <Grid>
                <Grid.Row>
                  <Grid.Column>
                    <span className="span-grey">ID: 734-876-6943</span>
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <Button
                      positive={this.props.status === "success"}
                      negative={this.props.status === "error"}
                      color={
                        this.props.status === "warning" ? "yellow" : "blue"
                      }
                    >
                      {this.props.status === "success" && "Approved"}
                      {this.props.status === "error" && "Rejected"}
                      {this.props.status === "warning" && "Processing"}
                    </Button>
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <span className="span-grey">Days Left to Process: 14</span>
                  </Grid.Column>
                </Grid.Row>
              </Grid>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row style={{ padding: "0px" }}>
            <Grid.Column>
              <Progress
                percent={this.props.percent}
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
