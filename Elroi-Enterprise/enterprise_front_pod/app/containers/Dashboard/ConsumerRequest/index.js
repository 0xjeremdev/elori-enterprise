import React from "react";
import {
  Button,
  Divider,
  Dropdown,
  Grid,
  Input,
  Menu,
  Progress,
  Segment,
} from "semantic-ui-react";
import styled from "styled-components";
import CircularChart from "../../../components/CircularChart";
import MultiRadialChart from "../../../components/MultiRadialChart";
import RequestItem from "./RequestItem";

const Container = styled(Segment)`
  .ui.input input {
    border-radius: 20px;
  }
  .request-btn {
    border-radius: 27px;
    background: linear-gradient(180deg, #fff570, #fea572);
    color: #2e4c9c;
  }
  .span-green {
    color: #04d68e;
  }
  .span-dark-blue {
    color: #334d6e;
  }
  .span-grey {
    color: #707683;
  }
  .ui.menu a.active.item {
    background: linear-gradient(90deg, #fea873, #fbe155) !important;
    border-left: 3px solid #7e52e8 !important;
    border-radius: 0px !important;
    color: #334d6e !important;
    opacity: 0.7;
  }
`;

class ConsumerRequest extends React.Component {
  state = {
    activeMenuItem: "processing",
  };

  render() {
    const { activeMenuItem } = this.state;
    const selectOptions = [
      { key: "1", value: "week", text: "This week" },
      { key: "2", value: "month", text: "This month" },
      { key: "3", value: "day", text: "Today" },
    ];
    return (
      <Grid>
        <Grid.Row>
          <Grid.Column width={11} style={{ paddingLeft: "40px" }}>
            <Container>
              <Grid>
                <Grid.Row>
                  <Grid.Column width={8}>
                    <b>
                      <span>
                        23 October, <span className="span-grey">Sunday</span>
                      </span>
                    </b>
                  </Grid.Column>
                  <Grid.Column width={8} textAlign="right">
                    <span className="span-grey">Show:</span>
                    <Dropdown
                      options={selectOptions}
                      style={{ color: "#0B7FD7" }}
                    />
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column width={10}>
                    <Input
                      fluid
                      placeholder="search data subject"
                      icon="search"
                    />
                  </Grid.Column>
                  <Grid.Column width={6} textAlign="right">
                    <Button className="request-btn">Request Extension</Button>
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <span className="span-dark-blue">
                      8 requests <span className="span-green">approved</span>{" "}
                      out of 10
                    </span>
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <Progress percent={80} success size="tiny" />
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <Menu secondary>
                      <Menu.Item
                        name="For Review"
                        active={activeMenuItem === "forReview"}
                        onClick={() => {
                          this.setState({ activeMenuItem: "forReview" });
                        }}
                      />
                      <Menu.Item
                        name="Processing"
                        active={activeMenuItem === "processing"}
                        onClick={() => {
                          this.setState({ activeMenuItem: "processing" });
                        }}
                      />
                      <Menu.Item
                        name="Complete"
                        active={activeMenuItem === "complete"}
                        onClick={() => {
                          this.setState({ activeMenuItem: "complete" });
                        }}
                      />
                      <Menu.Item
                        name="Rejected"
                        active={activeMenuItem === "rejected"}
                        onClick={() => {
                          this.setState({ activeMenuItem: "rejected" });
                        }}
                      />
                    </Menu>
                  </Grid.Column>
                </Grid.Row>
                <Divider />
                <Grid.Row>
                  <Grid.Column>
                    <RequestItem percent={96} status="success" />
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <RequestItem percent={60} status="error" />
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <RequestItem percent={80} status="warning" />
                  </Grid.Column>
                </Grid.Row>
                    <Button fluid attached="bottom">Next Page</Button>
              </Grid>
            </Container>
          </Grid.Column>
          <Grid.Column width={5}>
            <Container>
              <Grid>
                <Grid.Row>
                  <Grid.Column width={8}>
                    <span>Progress</span>
                  </Grid.Column>
                  <Grid.Column width={8} textAlign="right">
                    <span className="span-grey">Show:</span>
                    <Dropdown
                      options={selectOptions}
                      style={{ color: "#0B7FD7" }}
                    />
                  </Grid.Column>
                </Grid.Row>
              </Grid>
              <Divider />
              <CircularChart />
            </Container>
            <Container>
              <MultiRadialChart />
            </Container>
          </Grid.Column>
        </Grid.Row>
      </Grid>
    );
  }
}

export default ConsumerRequest;
