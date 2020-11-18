import React from "react";
import styled from "styled-components";
import { Button, Divider, Form, Grid, Icon, Image } from "semantic-ui-react";

import ColorPicker from "../../../../components/ColorPicker";
import noImage from "../../../../assets/images/no-img.png";
import { formAnswerTypeOptions } from "../../../../constants/constants";
import { consumerRequestFormApis } from "../../../../utils/api/setting/requestform";

const Container = styled(Grid)`
  label,
  .ui.form label {
    color: #959494;
    margin-left: 10px;
  }
  .ui.form input,
  .ui.form .dropdown {
    border-radius: 20px !important;
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

class ConfigureRequest extends React.Component {
  state = {
    logoUrl: "",
    backUrl: "",
    logoFile: null,
    logoFileName: "",
    logoBS64: null,
    backImg: null,
    backImgName: "",
    backImgBS64: null,
    siteColor: { r: 255, g: 120, b: 0, a: 1 },
    siteTheme: { r: 255, g: 120, b: 0, a: 1 },
    lanchUrl: "",
    companyName: "",
    residentState: "",
    additionalQuestions: [
      { key: 1, question: "", value: "" },
      { key: 2, question: "", value: "" },
      { key: 3, question: "", value: "" },
    ],
  };

  initState = ({
    additional_configuration,
    background_image,
    company_name,
    website_launched_to,
    logo,
    site_color,
    site_theme,
  }) => {
    this.setState({
      additionalQuestions: additional_configuration,
      backUrl: background_image,
      companyName: company_name,
      lanchUrl: website_launched_to,
      logoUrl: logo,
      siteColor: site_color,
      siteTheme: site_theme,
    });
  };

  componentDidMount() {
    const enterprise_id = localStorage.getItem("enterprise_id")
    consumerRequestFormApis
      .getConsumerRequestForm(enterprise_id)
      .then((res) => {
        this.initState(res);
      })
      .catch((err) => console.log("err", err));
  }

  onLogoChange = (e) => {
    const self = this;
    this.setState(
      { logoFile: e.target.files[0], logoFileName: e.target.files[0].name },
      () => {
        var fr = new FileReader();
        fr.onload = function() {
          self.setState({ logoBS64: fr.result });
        };
        fr.readAsDataURL(this.state.logoFile);
      }
    );
  };

  onBackImgChange = (e) => {
    const self = this;
    this.setState(
      { backImg: e.target.files[0], backImgName: e.target.files[0].name },
      () => {
        var fr = new FileReader();
        fr.onload = function() {
          self.setState({ backImgBS64: fr.result });
        };
        fr.readAsDataURL(this.state.backImg);
      }
    );
  };

  setSiteColor = (siteColor) => {
    this.setState({ siteColor });
  };

  setSiteTheme = (siteTheme) => {
    this.setState({ siteTheme });
  };

  setAdditionalQuestion = (index, property, value) => {
    const { additionalQuestions } = this.state;
    additionalQuestions[index][property] = value;
    this.setState({ additionalQuestions });
  };

  handleSave = () => {
    consumerRequestFormApis
      .setConsumerRequestForm(this.state)
      .then((res) => console.log(res));
  };

  render() {
    const {
      logoFile,
      logoUrl,
      backUrl,
      logoBS64,
      backImg,
      backImgBS64,
      additionalQuestions,
    } = this.state;
    const enterprise_id = localStorage.getItem("enterprise_id");
    const fullUrl = window.location.href;
    const arr = fullUrl.split("/");
    const requestUrl = `${arr[0]}//${arr[2]}/request/${enterprise_id}`;
    return (
      <Container>
        <Grid.Row verticalAlign="middle">
          <Grid.Column width={3}>
            <Image
              src={logoFile ? logoBS64 : logoUrl}
              style={{ width: "120px", height: "120px" }}
              size="small"
              bordered
            />
          </Grid.Column>
          <Grid.Column width={4}>
            <input type="file" id="logo" hidden onChange={this.onLogoChange} />
            <p>Upload Logo</p>
            <label htmlFor="logo" className="upload-button">
              <Icon name="upload" />
              Upload
            </label>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column width={8}>
            <Grid>
              <Grid.Row columns={2} verticalAlign="middle">
                <Grid.Column>
                  <label>
                    <b>Site Color</b>
                  </label>
                </Grid.Column>
                <Grid.Column>
                  <ColorPicker
                    setColor={this.setSiteColor}
                    color={this.state.siteColor}
                  />
                </Grid.Column>
              </Grid.Row>
            </Grid>
          </Grid.Column>
          <Grid.Column width={8}>
            <Grid>
              <Grid.Row columns={2} verticalAlign="middle">
                <Grid.Column>
                  <label>
                    <b>Site Theme</b>
                  </label>
                </Grid.Column>
                <Grid.Column>
                  <ColorPicker
                    setColor={this.setSiteTheme}
                    color={this.state.siteTheme}
                  />
                </Grid.Column>
              </Grid.Row>
              <Grid.Row columns={2} verticalAlign="middle">
                <Grid.Column>
                  <Image
                    src={backImg ? backImgBS64 : backUrl}
                    size="small"
                    style={{ width: "120px", height: "60px" }}
                    bordered
                  />
                  <input
                    type="file"
                    id="backImg"
                    hidden
                    onChange={this.onBackImgChange}
                  />
                  <label>
                    <b>Background Image</b>
                  </label>
                </Grid.Column>
                <Grid.Column>
                  <label htmlFor="backImg" className="upload-button">
                    Choose File
                  </label>
                </Grid.Column>
              </Grid.Row>
            </Grid>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row verticalAlign="middle">
          <Grid.Column width={6}>
            <Form>
              <Form.Input
                label="Website Launched to"
                value={requestUrl}
              />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column width={5}>
            <Form>
              <Form.Input
                label="Company Name"
                onChange={(e, { value }) =>
                  this.setState({ companyName: value })
                }
                value={this.state.companyName}
              />
            </Form>
          </Grid.Column>
          <Grid.Column width={5}>
            <Form>
              <Form.Input
                label="Resident State"
                onChange={(e, { value }) =>
                  this.setState({ residentState: value })
                }
                value={this.state.residentState}
              />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column>
            <Divider horizontal>Verification Questions</Divider>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column width={6}>
            <Form>
              <Form.Input
                label="Question 1"
                value={additionalQuestions[0].question}
                onChange={(e, { value }) =>
                  this.setAdditionalQuestion(0, "question", value)
                }
              />
            </Form>
          </Grid.Column>
          <Grid.Column width={4}>
            <Form>
              <Form.Dropdown
                label="Value"
                selection
                options={formAnswerTypeOptions}
                value={additionalQuestions[0].value}
                onChange={(e, { value }) =>
                  this.setAdditionalQuestion(0, "value", value)
                }
              />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column width={6}>
            <Form>
              <Form.Input
                label="Question 2"
                value={additionalQuestions[1].question}
                onChange={(e, { value }) =>
                  this.setAdditionalQuestion(1, "question", value)
                }
              />
            </Form>
          </Grid.Column>
          <Grid.Column width={4}>
            <Form>
              <Form.Dropdown
                label="Value"
                selection
                options={formAnswerTypeOptions}
                value={additionalQuestions[1].value}
                onChange={(e, { value }) =>
                  this.setAdditionalQuestion(1, "value", value)
                }
              />
            </Form>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <Grid.Column width={6}>
            <Form>
              <Form.Input
                label="Question 3"
                value={additionalQuestions[2].question}
                onChange={(e, { value }) =>
                  this.setAdditionalQuestion(2, "question", value)
                }
              />
            </Form>
          </Grid.Column>
          <Grid.Column width={4}>
            <Form>
              <Form.Dropdown
                label="Value"
                selection
                options={formAnswerTypeOptions}
                value={additionalQuestions[2].value}
                onChange={(e, { value }) =>
                  this.setAdditionalQuestion(2, "value", value)
                }
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

export default ConfigureRequest;
