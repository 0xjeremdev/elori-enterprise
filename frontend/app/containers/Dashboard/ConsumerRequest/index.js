import { map, reject } from "lodash";
import styled from "styled-components";
import React, { useCallback, useState } from "react";
import {
  Button,
  Divider,
  Dropdown,
  Form,
  Grid,
  Input,
  Menu,
  Modal,
  Progress,
  Segment,
  TextArea,
} from "semantic-ui-react";
import CircularChart from "../../../components/CircularChart";
import {
  CCPA,
  COMPLETE,
  GDPR,
  PROCESS,
  REJECT,
  REVIEW,
} from "../../../constants/constants";
import { API_ENDPOINT_URL } from "../../../constants/defaults";
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
const CommentModal = ({ open, onClose, onSubmit }) => {
  const [comment, setComment] = useState();
  const handleChangeComment = useCallback((event, { value }) => {
    setComment(value);
  }, []);

  const submitComment = useCallback(() => {
    onSubmit(comment);
    setComment("");
  }, [comment]);

  const onCancel = () => {
    setComment("");
    onClose();
  };

  return (
    <Modal open={open}>
      <Modal.Header>Add Comment</Modal.Header>
      <Modal.Content>
        <Grid>
          <Grid.Row>
            <Grid.Column>
              <Form>
                <TextArea
                  rows={5}
                  value={comment}
                  onChange={handleChangeComment}
                />
              </Form>
            </Grid.Column>
          </Grid.Row>
        </Grid>
      </Modal.Content>
      <Modal.Actions>
        <Button onClick={onCancel}>Cancel</Button>
        <Button onClick={submitComment}>Okay</Button>
      </Modal.Actions>
    </Modal>
  );
};

class ConsumerRequest extends React.Component {
  state = {
    activeMenuItem: "processing",
    searchKey: "",
    consumerList: [],
    count: [],
    selRequestItem: {},
    detailModal: false,
    filterStatus: REVIEW,
    commentModal: false,
    reportDataQuery: {},
  };

  handleDetailModal = (id) => {
    consumerRequestApis.getConsumerRequestObject(id).then((res) => {
      const selRequestItem = res.data;
      this.setState({ selRequestItem, detailModal: true });
    });
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
    this.interval = setInterval(this.initState, 300000);
  }

  componentWillUnmount() {
    clearInterval(this.interval);
  }

  updateRequestItem = (id, status, extend) => {
    if (status === PROCESS || status === REJECT) {
      this.setState({
        commentModal: true,
        nextStatus: status,
        selectedId: id,
        nextExtend: extend,
      });
    } else {
      this.setState({ detailModal: false });
      consumerRequestApis
        .updateConsumerRequest({ id, status, extend })
        .then((res) => {
          this.initState();
        });
    }
  };

  submitComment = (comment) => {
    const { nextStatus, selectedId, nextExtend } = this.state;
    this.setState({ detailModal: false, commentModal: false });
    consumerRequestApis
      .updateConsumerRequest({
        id: selectedId,
        status: nextStatus,
        extend: nextExtend,
        comment,
      })
      .then((res) => {
        this.initState();
      });
  };

  handleFetchReport = () => {
    const { reportDataQuery } = this.state;
    const enterprise_id = localStorage.getItem("enterprise_id");
    const {
      start_date,
      end_date,
      report_type,
      timeframe,
      status,
    } = reportDataQuery;
    const url = `${API_ENDPOINT_URL}/consumer/report/${enterprise_id}?start_date=${start_date}&end_date=${end_date}&report_type=${report_type}&timeframe=${timeframe}&status=${status}`;
    const tempLink = document.createElement("a");
    tempLink.href = url;
    tempLink.target = "_blank";
    tempLink.download = `report.${report_type}`;
    tempLink.click();
  };

  render() {
    const { consumerList, filterStatus, searchKey } = this.state;
    const selectOptions = [
      { key: "1", value: "week", text: "This week" },
      { key: "2", value: "month", text: "This month" },
      { key: "3", value: "day", text: "Today" },
    ];
    const consumerRenderList = consumerList.filter(
      (item) => item.status === filterStatus
    );
    let updatedRenderList = [];
    consumerRenderList.forEach((item) => {
      let flag = false;
      Object.entries(item).forEach(([key, value]) => {
        if (String(value).includes(searchKey)) {
          flag = true;
          return;
        }
      });
      if (flag) {
        updatedRenderList.push(item);
      }
    });
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
    const statusOptions = [
      { key: 1, value: REVIEW, text: "Review" },
      { key: 2, value: PROCESS, text: "Process" },
      { key: 3, value: COMPLETE, text: "Complete" },
      { key: 4, value: REJECT, text: "Reject" },
    ];
    const reportOptions = [
      { key: 1, value: "pdf", text: "PDF" },
      { key: 2, value: "csv", text: "CSV" },
    ];
    const timeframeOptions = [
      { key: 1, value: CCPA, text: "CCPA" },
      { key: 2, value: GDPR, text: "GDPR" },
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
                      value={searchKey || ""}
                      onChange={(e) =>
                        this.setState({ searchKey: e.target.value })
                      }
                    />
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
                  <Grid.Column width={4}>
                    <Form>
                      <Form.Input
                        type="date"
                        size="mini"
                        label="Start Date"
                        value={this.state.reportDataQuery.start_date || ""}
                        onChange={(e, { value }) =>
                          this.setState({
                            reportDataQuery: {
                              ...this.state.reportDataQuery,
                              start_date: value,
                            },
                          })
                        }
                      />
                    </Form>
                  </Grid.Column>
                  <Grid.Column width={4}>
                    <Form>
                      <Form.Input
                        type="date"
                        size="mini"
                        label="End Date"
                        value={this.state.reportDataQuery.end_date || ""}
                        onChange={(e, { value }) =>
                          this.setState({
                            reportDataQuery: {
                              ...this.state.reportDataQuery,
                              end_date: value,
                            },
                          })
                        }
                      />
                    </Form>
                  </Grid.Column>
                </Grid.Row>
                <Grid.Row>
                  <Grid.Column width={4}>
                    <Form>
                      <Form.Dropdown
                        selection
                        label="Status"
                        options={statusOptions}
                        value={this.state.reportDataQuery.status}
                        onChange={(e, { value }) =>
                          this.setState({
                            reportDataQuery: {
                              ...this.state.reportDataQuery,
                              status: value,
                            },
                          })
                        }
                      />
                    </Form>
                  </Grid.Column>
                  <Grid.Column width={4}>
                    <Form>
                      <Form.Dropdown
                        selection
                        label="Report Type"
                        options={reportOptions}
                        value={this.state.reportDataQuery.report_type || ""}
                        onChange={(e, { value }) =>
                          this.setState({
                            reportDataQuery: {
                              ...this.state.reportDataQuery,
                              report_type: value,
                            },
                          })
                        }
                      />
                    </Form>
                  </Grid.Column>
                  <Grid.Column width={4}>
                    <Form>
                      <Form.Dropdown
                        selection
                        label="Timeframe"
                        options={timeframeOptions}
                        value={this.state.reportDataQuery.timeframe}
                        onChange={(e, { value }) =>
                          this.setState({
                            reportDataQuery: {
                              ...this.state.reportDataQuery,
                              timeframe: value,
                            },
                          })
                        }
                      />
                    </Form>
                  </Grid.Column>
                  <Grid.Column width={4}>
                    <br />
                    <Button
                      className="request-btn"
                      onClick={this.handleFetchReport}
                    >
                      Submit
                    </Button>
                  </Grid.Column>
                </Grid.Row>
                <Divider />
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
                {map(updatedRenderList, (item) => (
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
                {updatedRenderList.length === 0 && (
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
            {/* <Container>
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
            </Container> */}
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
        <CommentModal
          open={this.state.commentModal}
          onSubmit={this.submitComment}
          onClose={() => this.setState({ commentModal: false })}
        />
      </Grid>
    );
  }
}

export default ConsumerRequest;
