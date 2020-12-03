import React from "react";
import { Button, Dropdown, Grid, Image, Input } from "semantic-ui-react";
import styled from "styled-components";
import ReCAPTCHA from "react-google-recaptcha";

import GlobalStyle from "../../../global-styles";
import noImg from "../../../assets/images/no-img.png";
import bk1 from "../../../assets/images/bk1.png";
import bk2 from "../../../assets/images/bk2.png";
import logo from "../../../assets/images/logo.png";
import ToggleButton from "../../../components/ToggleButton";
import Dropzone from "../../../components/Dropzone";
import { consumerRequestFormApis } from "../../../utils/api/setting/requestform";
import { consumerRequestApis } from "../../../utils/api/consumer/request";
import ConfirmModal from "./ConfirmModal";

const RequestFormContainer = styled.div`
  p.title {
    color: #067cd3;
    font-size: 44px;
    font-family: Poppins Light;
    font-weight: 100;
  }
  p.desc {
    color: #544837;
    font-size: 25px;
    font-weight: 500;
  }
  img.logo {
    margin-top: 50px;
  }
  .ui.button.yellow {
    border-radius: 27px;
    background: linear-gradient(180deg, #fff570, #fea572);
    color: #274497;
    font-family: Poppins Light;
    font-size: 23px;
    font-weight: 100;
    text-align: center;
    letter-spacing: 2.2px;
  }
  .control-label {
    font-family: AvenirNext-DemiBold;
    font-size: 25px;
    color: #544837;
  }
  .row.form-row {
    padding: 25px 200px;
    width: 1000px !important;
  }
  .ui.input.form-input input {
    border: 2px solid
      ${(props) =>
        `rgb(${props.fontColor.r},${props.fontColor.g},${props.fontColor.b},${
          props.fontColor.a
        })`};
    font-size: 16px;
  }
  .ui.dropdown.form-select {
    border: 2px solid
      ${(props) =>
        `rgb(${props.fontColor.r},${props.fontColor.g},${props.fontColor.b},${
          props.fontColor.a
        })`};
    font-size: 16px;
  }
  .captcha > div > div {
    margin: auto;
  }
  .column.bk-upside {
    -webkit-transform: rotate(180deg);
    -moz-transform: rotate(180deg);
    -o-transform: rotate(180deg);
    -ms-transform: rotate(180deg);
    transform: rotate(180deg);
  }
  .desc-center {
    color: #067cd3;
    font-family: Poppins Light;
    font-size: 20px;
    font-weight: 100;
    line-height: 38px;
    text-align: center;
  }
  section.container .dropzone {
    border: dashed 2px
      ${(props) =>
        `rgb(${props.fontColor.r},${props.fontColor.g},${props.fontColor.b},${
          props.fontColor.a
        })`};
    text-align: center;
    padding: 40px 50px 50px;
    margin: auto;
    &:focus {
      outline-color: ${(props) =>
        `rgb(${props.fontColor.r},${props.fontColor.g},${props.fontColor.b},${
          props.fontColor.a
        })`} !important;
    }
  }
  span.power-by {
    font-size: 26px;
    font-weight: 400;
    letter-spacing: 1px;
    color: #bec0c0;
  }
`;

class Request extends React.Component {
  state = {
    logoUrl: null,
    backUrl: null,
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
    enableSubmit: false,
    first_name: "",
    last_name: "",
    email: "",
    state_resident: true,
    request_type: "",
    file: null,
    additional_fields: [],
    confirmModal: false,
    sending: false,
  };

  onCaptcha = (value) => {
    this.setState({ enableSubmit: true });
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
    let additional_fields = [];
    additional_configuration.forEach((item) => {
      additional_fields.push({ question: item.question, value: "" });
    });
    this.setState({ ...this.state, additional_fields: [...additional_fields] });
  };

  componentDidMount() {
    const { id } = this.props.match.params;
    consumerRequestFormApis.getConsumerRequestForm(id).then((res) => {
      this.initState(res);
    });
  }

  handleStateChange = (value, index) => {
    const { additional_fields } = this.state;
    additional_fields[index].value = value;
    this.setState({ ...this.state, additional_fields: [...additional_fields] });
  };

  uploadFile = (files) => {
    this.setState({ file: files[0] });
  };

  handleUpload = () => {
    const { id } = this.props.match.params;
    this.setState({ sending: true });
    consumerRequestApis
      .sendConsumerRequest(this.state, id)
      .then((res) => this.setState({ confirmModal: true, sending: false }));
  };

  render() {
    const {
      logoUrl,
      backUrl,
      companyName,
      additionalQuestions,
      siteColor,
    } = this.state;
    const requestTypeOptions = [
      { key: "1", text: "Return", value: "request_return" },
      { key: "2", text: "Delete", value: "request_delete" },
      { key: "3", text: "Modify", value: "request_modify" },
    ];
    const booleanTypeOptions = [
      { key: "1", text: "Yes", value: true },
      { key: "2", text: "No", value: false },
    ];
    return (
      <RequestFormContainer fontColor={siteColor}>
        <GlobalStyle />
        <Grid>
          <Grid.Row
            style={{
              background: `url(${backUrl})`,
              backgroundSize: "contain",
              backgroundPosition: "center",
            }}
          >
            <Grid.Column width="3">
              <Image
                className="logo"
                src={logoUrl ? logoUrl : noImg}
                size="tiny"
                centered
              />
            </Grid.Column>
            <Grid.Column
              width="13"
              style={{ marginTop: "120px", padding: "0px 200px 0px 0px" }}
            >
              <p className="title">{companyName}'s Privacy Request Form</p>
              <p className="desc">
                Your privacy is very important to us. STATE law grants
                California residents rights relating to their personal
                information. If you would like to make a request to access or
                delete your information, please complete the form below. All
                fields marked with an asterisk (*) are required so we can
                properly verify your identity.
                <br />
                <br />
                <br /> For enhanced user experience, use Google Chrome, the most
                recent version of Internet Explorer or Safari
              </p>
              <div style={{ textAlign: "center", padding: "30px" }}>
                <Button className="yellow" size="medium">
                  Get Started
                </Button>
              </div>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row>
            <Grid.Column width="16">
              <Image src={bk1} fluid />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row textAlign="center">
            <Grid.Column width="16">
              <p className="title">LET’S GET STARTED!</p>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* I am a STATE resident</p>
              <ToggleButton
                fontColor={siteColor}
                value={this.state.state_resident}
                onActive={(active) => this.setState({ state_resident: active })}
              />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* First Name</p>
              <Input
                className="form-input"
                placeholder="hello, nice to meet you, what is your first name?"
                fluid
                value={this.state.first_name}
                onChange={(e, { value }) =>
                  this.setState({ first_name: value })
                }
              />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* Last Name</p>
              <Input
                className="form-input"
                placeholder="let's get more connected, and your last name?"
                fluid
                value={this.state.last_name}
                onChange={(e, { value }) => this.setState({ last_name: value })}
              />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* Email Address</p>
              <Input
                className="form-input"
                placeholder="and how about your email address?"
                fluid
                value={this.state.email}
                onChange={(e, { value }) => this.setState({ email: value })}
              />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* Request Type</p>
              <Dropdown
                fluid
                selection
                className="form-select"
                options={requestTypeOptions}
                value={this.state.request_type}
                onChange={(e, { value }) =>
                  this.setState({ request_type: value })
                }
              />
            </Grid.Column>
          </Grid.Row>
          {additionalQuestions.map((item, index) => (
            <Grid.Row className="form-row">
              <Grid.Column>
                <p className="control-label">* {item.question}</p>
                {item.value === "boolean" && (
                  <Dropdown
                    fluid
                    selection
                    className="form-select"
                    options={booleanTypeOptions}
                    onChange={(e, { value }) =>
                      this.handleStateChange(value, index)
                    }
                  />
                )}
                {item.value === "text" && (
                  <Input
                    className="form-input"
                    fluid
                    onChange={(e, { value }) =>
                      this.handleStateChange(value, index)
                    }
                  />
                )}
                {item.value === "file" && (
                  <Input
                    className="form-input"
                    type="file"
                    accept="image/x-png,image/jpg,image/jpeg" 
                    fluid
                    onChange={(e, { value }) =>
                      this.handleStateChange(value, index)
                    }
                  />
                )}
              </Grid.Column>
            </Grid.Row>
          ))}
          <Grid.Row>
            <Grid.Column width="16">
              <ReCAPTCHA
                sitekey="6LchsOIZAAAAAJmYZDbHKBGtYXfNJuBz8eM0om_o"
                onChange={this.onCaptcha}
                onExpired={() => this.setState({ enableSubmit: false })}
                className="captcha"
              />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row>
            <Grid.Column className="bk-upside" width="16">
              <Image src={bk1} fluid />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row textAlign="center" centered>
            <Grid.Column width="14">
              <p className="desc-center">
                Please upload any document that has been identified in this form
                as required for verification. If the required document is not
                uploaded within 5 business days of the date of submission of
                this request, this request will be rejected
              </p>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row centered>
            <Grid.Column width="10">
              <Dropzone onDrop={this.uploadFile} />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row textAlign="center">
            <Grid.Column width="16">
              <Button
                className="yellow"
                size="medium"
                disabled={!this.state.enableSubmit}
                onClick={this.handleUpload}
                loading={this.state.sending}
              >
                Submit!
              </Button>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row textAlign="center">
            <Grid.Column width="16">
              <span className="power-by">
                Powered by <Image src={logo} as="span" />
              </span>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row textAlign="left">
            <Grid.Column width="16">
              <p className="desc-center">
                If you need assistance please call 1-800-123-45678
              </p>
              <p className="desc-center">
                This site is intended for United States Residents only
              </p>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row>
            <Grid.Column width="16">
              <Image src={bk2} fluid />
            </Grid.Column>
          </Grid.Row>
        </Grid>
        <ConfirmModal
          open={this.state.confirmModal}
          onClose={() => this.setState({ confirmModal: false })}
        />
      </RequestFormContainer>
    );
  }
}

export default Request;
