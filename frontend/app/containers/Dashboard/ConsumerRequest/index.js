import { map, reject } from "lodash";
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
import {
  COMPLETE,
  PROCESS,
  REJECT,
  REVIEW,
} from "../../../constants/constants";
import { consumerRequestApis } from "../../../utils/api/consumer/request";
import RequestDetailModal from "./RequestDetailModal";
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
    consumerList: [],
    count: [],
    selRequestItem: {},
    detailModal: false,
    filterStatus: REVIEW,
  };

  handleDetailModal = (id) => {
    const { consumerList } = this.state;
    const selRequestItem = consumerList.find((item) => item.id === id);
    this.setState({ selRequestItem, detailModal: true });
  };

  initState = () => {
    consumerRequestApis.getConsumerRequest().then((res) => {
      if (res) {
        this.setState({ consumerList: res.results, count: res.count });
      }
    });
  };

  componentDidMount() {
    this.initState();
  }

  updateRequestItem = (id, status, extend) => {
    this.setState({ detailModal: false });
    consumerRequestApis
      .updateConsumerRequest(id, status, extend)
      .then((res) => {
        this.initState();
      });
  };

  render() {
    const { consumerList, filterStatus } = this.state;
    const selectOptions = [
      { key: "1", value: "week", text: "This week" },
      { key: "2", value: "month", text: "This month" },
      { key: "3", value: "day", text: "Today" },
    ];
    const consumerRenderList = consumerList.filter(
      (item) => item.status === filterStatus
    );
    const totalRequestsCount = consumerList.length;
    const rejectedRequestsCount = consumerList.filter(
      (item) => item.status === REJECT
    ).length;
    const reviewRequestsCount = consumerList.filter(
      (item) => item.status === REVIEW
    ).length;
    const completeRequestsCount = consumerList.filter(
      (item) => item.status === COMPLETE
    ).length;
    return (
      <Grid>
        <Grid.Row>
          <Grid.Column width={11} style={{ paddingLeft: "40px" }}>
            <Container>
              <Grid>
                <Grid.Row>
                  <Grid.Column width={8}>
                    <b>
                      <span>{new Date().toDateString()}</span>
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
                      {totalRequestsCount -
                        reviewRequestsCount -
                        rejectedRequestsCount}{" "}
                      requests <span className="span-green">approved</span> out
                      of {totalRequestsCount}
                    </span>
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <Progress
                      percent={
                        ((totalRequestsCount -
                          reviewRequestsCount -
                          rejectedRequestsCount) /
                          totalRequestsCount) *
                        100
                      }
                      success
                      size="tiny"
                    />
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column>
                    <Menu secondary>
                      <Menu.Item
                        name="For Review"
                        active={filterStatus === REVIEW}
                        onClick={() => {
                          this.setState({
                            filterStatus: REVIEW,
                          });
                        }}
                      />
                      <Menu.Item
                        name="Processing"
                        active={filterStatus === PROCESS}
                        onClick={() => {
                          this.setState({
                            filterStatus: PROCESS,
                          });
                        }}
                      />
                      <Menu.Item
                        name="Complete"
                        active={filterStatus === COMPLETE}
                        onClick={() => {
                          this.setState({
                            filterStatus: COMPLETE,
                          });
                        }}
                      />
                      <Menu.Item
                        name="Rejected"
                        active={filterStatus === REJECT}
                        onClick={() => {
                          this.setState({
                            filterStatus: REJECT,
                          });
                        }}
                      />
                    </Menu>
                  </Grid.Column>
                </Grid.Row>
                <Divider />
                {map(consumerRenderList, (item) => (
                  <Grid.Row key={item.created_at}>
                    <Grid.Column
                      onClick={() => {
                        this.handleDetailModal(item.id);
                      }}
                    >
                      <RequestItem status="success" data={item} />
                    </Grid.Column>
                  </Grid.Row>
                ))}
                {consumerRenderList.length === 0 && (
                  <Grid.Row textAlign="center">
                    <Grid.Column>
                      <p>No Consumer Request</p>
                    </Grid.Column>
                  </Grid.Row>
                )}
                <Button fluid attached="bottom">
                  Next Page
                </Button>
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
              <CircularChart
                total={totalRequestsCount}
                validCount={
                  totalRequestsCount -
                  reviewRequestsCount -
                  rejectedRequestsCount
                }
              />
            </Container>
            <Container>
              <MultiRadialChart
                totalValidCount={
                  totalRequestsCount -
                  reviewRequestsCount -
                  rejectedRequestsCount
                }
                progressCount={
                  totalRequestsCount -
                  reviewRequestsCount -
                  rejectedRequestsCount -
                  completeRequestsCount
                }
                completeCount={completeRequestsCount}
              />
            </Container>
          </Grid.Column>
        </Grid.Row>
        <RequestDetailModal
          data={this.state.selRequestItem}
          open={this.state.detailModal}
          onUpdate={(id, status, extend) =>
            this.updateRequestItem(id, status, extend)
          }
          onClose={() => this.setState({ detailModal: false })}
        />
      </Grid>
    );
  }
}

export default ConsumerRequest;
