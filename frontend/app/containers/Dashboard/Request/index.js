import React from "react";
import faker from "faker";
import styled from "styled-components";
import ReCAPTCHA from "react-google-recaptcha";
import { Button, Dropdown, Grid, Image, Input } from "semantic-ui-react";

import GlobalStyle from "../../../global-styles";
import noImg from "../../../assets/images/no-img.png";
import logo from "../../../assets/images/logo.png";
import Dropzone from "../../../components/Dropzone";
import { consumerRequestFormApis } from "../../../utils/api/setting/requestform";
import { consumerRequestApis } from "../../../utils/api/consumer/request";
import ConfirmModal from "./ConfirmModal";
import { EUList } from "../../../constants/constants";
import {
  getFileExtenstion,
  getFileSizeMb,
  isEmailValid,
} from "../../../utils/validation";
import { withToastManager } from "react-toast-notifications";
import VerifyEmailModal from "./VerifyEmailModal";
import { baseToImgSrc } from "../../../utils/file";

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
  .error-msg {
    color: red;
    font-size: 12px;
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
    additionalQuestions: [],
    enableSubmit: false,
    first_name: "",
    first_name_valid: true,
    last_name: "",
    last_name_valid: true,
    email: "",
    email_valid: true,
    request_type: "",
    request_type_valid: true,
    country: "",
    country_valid: true,
    state: "",
    file: null,
    additional_fields: [],
    confirmModal: false,
    sending: false,
    reset: false, //for dropzone
    verifyEmailModal: false,
    privacyDescription: "",
    fileDescription: "",
  };

  onCaptcha = (value) => {
    this.setState({ enableSubmit: true });
  };

  inputValid = () => {
    let isValid = true;
    const { first_name, last_name, email, request_type, country } = this.state;
    if (country === "") {
      this.setState({ country_valid: false });
      isValid = false;
    }
    if (first_name === "") {
      this.setState({ first_name_valid: false });
      isValid = false;
    }
    if (last_name === "") {
      this.setState({ last_name_valid: false });
      isValid = false;
    }
    if (!isEmailValid(email)) {
      this.setState({ email_valid: false });
      isValid = false;
    }
    if (request_type === "") {
      this.setState({ request_type_valid: false });
      isValid = false;
    }
    return isValid;
  };

  initState = ({
    additional_configuration,
    background_image_data,
    company_name,
    website_launched_to,
    logo_data,
    site_color,
    site_theme,
    privacy_description,
    file_description,
  }) => {
    const logo = baseToImgSrc(logo_data);
    const background_image = baseToImgSrc(background_image_data);
    const additionalConfiguration =
      typeof additional_configuration === "string"
        ? JSON.parse(additional_configuration)
        : additional_configuration;
    this.setState({
      additionalQuestions: additionalConfiguration,
      backUrl: background_image,
      companyName: company_name,
      lanchUrl: website_launched_to,
      logoUrl: logo,
      siteColor: site_color,
      country: "United States of America",
      siteTheme: site_theme,
      privacyDescription: privacy_description,
      fileDescription: file_description,
    });
    let additional_fields = [];
    additionalConfiguration.forEach((item) => {
      additional_fields.push({ question: item.question, value: "" });
    });
    this.setState({ ...this.state, additional_fields: [...additional_fields] });
  };

  componentDidMount() {
    const { id } = this.props.match.params;
    consumerRequestFormApis.getConsumerRequestFormByToken(id).then((res) => {
      this.initState(res);
    });
  }

  handleStateChange = (value, index) => {
    const { additional_fields } = this.state;
    additional_fields[index].value = value;
    this.setState({ ...this.state, additional_fields: [...additional_fields] });
  };

  uploadFile = (files) => {
    const fileExtension = getFileExtenstion(files[0].name);
    if (
      fileExtension === "docx" ||
      fileExtension === "doc" ||
      fileExtension === "pdf" ||
      fileExtension === "jpg" ||
      fileExtension === "png" ||
      fileExtension === "jpeg" ||
      fileExtension === "xlsx"
    ) {
      if (getFileSizeMb(files[0].size) < 3) {
        this.setState({ file: files[0], reset: false });
      } else {
        alert("File Size are restricted to 3MB");
        this.setState({ reset: true });
      }
    } else {
      alert("Document only allow .docx, .doc, .pdf or .xlsx");
      this.setState({ reset: true });
    }
  };

  sendCodeToEmail = () => {
    const { id } = this.props.match.params;
    const { email } = this.state;
    this.setState({ verifyEmailModal: true });
    consumerRequestApis
      .sendOneCodeEmail(id, email)
      .then((res) => console.log(res))
      .catch((e) => alert(e));
  };

  handleUpload = () => {
    if (this.inputValid()) {
      const { id } = this.props.match.params;
      let timeframe = 0;
      this.setState({ sending: true });

      if (this.state.country === "United States of America") {
        timeframe = 1;
      }

      consumerRequestApis
        .sendConsumerRequest({ ...this.state, timeframe }, id)
        .then((res) => {
          let initFields = [];
          this.state.additional_fields.map((field) => {
            initFields.push({ question: field.question, value: "" });
          });
          this.setState({
            confirmModal: true,
            sending: false,
            first_name: "",
            last_name: "",
            email: "",
            request_type: "",
            country: "United States of America",
            state: "",
            reset: true,
            file: null,
            additional_fields: [...initFields],
          });
        })
        .catch((err) => {
          alert("Something went wrong while send request");
          this.setState({ sending: false });
        });
    }
  };

  render() {
    const {
      logoUrl,
      backUrl,
      companyName,
      additionalQuestions,
      siteColor,
      verifyEmailModal,
      privacyDescription,
      fileDescription,
    } = this.state;
    const { id } = this.props.match.params;
    const requestTypeOptions = [
      { key: "1", text: "Return", value: "request_return" },
      { key: "2", text: "Delete", value: "request_delete" },
      { key: "3", text: "Modify", value: "request_modify" },
      { key: "4", text: "Do Not Sell", value: "request_dns" },
    ];
    const booleanTypeOptions = [
      { key: "1", text: "Yes", value: true },
      { key: "2", text: "No", value: false },
    ];
    const countryOptions = faker.definitions.address.country.map(
      (country, index) => ({
        key: `country-${index}`,
        text: country,
        value: country,
      })
    );
    const stateOptions = faker.definitions.address.state.map(
      (state, index) => ({
        key: `state-${index}`,
        text: state,
        value: state,
      })
    );
    return (
      <RequestFormContainer fontColor={siteColor}>
        <GlobalStyle />
        <Grid>
          <Grid.Row
            style={{
              background: `url(${backUrl})`,
              backgroundSize: "contain",
              backgroundPosition: "center",
              minHeight: "60vh",
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
              <p className="title">
                {companyName && `${companyName}'s`} Privacy Request Form
              </p>
              <p className="desc">{privacyDescription}</p>
              <div style={{ textAlign: "center", padding: "30px" }}>
                <Button className="yellow" size="medium">
                  <a href="#started">Get Started</a>
                </Button>
              </div>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row textAlign="center">
            <Grid.Column width="16">
              <p className="title" id="started">
                LET’S GET STARTED!
              </p>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* I am a Resident of</p>
              {!this.state.country_valid && (
                <label className="error-msg">Country is required</label>
              )}
              <Dropdown
                className="form-select"
                fluid
                selection
                options={countryOptions}
                selectOnBlur={false}
                search
                error={!this.state.country_valid}
                onChange={(e, { value }) => {
                  this.setState({ country: value, country_valid: true });
                }}
                value={this.state.country}
              />
              <br />
              {this.state.country === "United States of America" && (
                <Dropdown
                  className="form-select"
                  fluid
                  selection
                  value={this.state.state}
                  options={stateOptions}
                  selectOnBlur={false}
                  search
                  onChange={(e, { value }) => {
                    this.setState({ state: value });
                  }}
                />
              )}
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* First Name</p>
              {!this.state.first_name_valid && (
                <label className="error-msg">
                  First name is required field
                </label>
              )}
              <Input
                className="form-input"
                placeholder="hello, nice to meet you, what is your first name?"
                fluid
                error={!this.state.first_name_valid}
                value={this.state.first_name}
                onChange={(e, { value }) =>
                  this.setState({ first_name: value, first_name_valid: true })
                }
              />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* Last Name</p>
              {!this.state.last_name_valid && (
                <label className="error-msg">Last name is required</label>
              )}
              <Input
                className="form-input"
                placeholder="let's get more connected, and your last name?"
                fluid
                error={!this.state.last_name_valid}
                value={this.state.last_name}
                onChange={(e, { value }) =>
                  this.setState({ last_name: value, last_name_valid: true })
                }
              />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* Email Address</p>
              {!this.state.email_valid && (
                <label className="error-msg">Email is invalid</label>
              )}
              <Input
                className="form-input"
                placeholder="and how about your email address?"
                fluid
                error={!this.state.email_valid}
                value={this.state.email}
                onChange={(e, { value }) =>
                  this.setState({ email: value, email_valid: true })
                }
              />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row className="form-row">
            <Grid.Column>
              <p className="control-label">* Request Type</p>
              {!this.state.request_type_valid && (
                <label className="error-msg">Request type is required</label>
              )}
              <Dropdown
                fluid
                selection
                className="form-select"
                options={requestTypeOptions}
                error={!this.state.request_type_valid}
                value={this.state.request_type}
                onChange={(e, { value }) =>
                  this.setState({
                    request_type: value,
                    request_type_valid: true,
                  })
                }
              />
            </Grid.Column>
          </Grid.Row>
          {additionalQuestions.map(
            (item, index) =>
              item.value && (
                <Grid.Row className="form-row" key={`input-${index}`}>
                  <Grid.Column>
                    <p className="control-label">* {item.question}</p>
                    {item.value === "boolean" && (
                      <Dropdown
                        fluid
                        selection
                        className="form-select"
                        value={
                          this.state.additional_fields[index] &&
                          this.state.additional_fields[index].value
                        }
                        options={booleanTypeOptions}
                        onChange={(e, { value }) =>
                          this.handleStateChange(value, index)
                        }
                      />
                    )}
                    {(item.value === "text" || item.value === "email") && (
                      <Input
                        className="form-input"
                        value={
                          this.state.additional_fields[index] &&
                          this.state.additional_fields[index].value
                        }
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
                        accept="image/jpg,image/jpeg"
                        fluid
                        onChange={(e, { value }) =>
                          this.handleStateChange(value, index)
                        }
                      />
                    )}
                  </Grid.Column>
                </Grid.Row>
              )
          )}
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
          <Grid.Row textAlign="center" centered>
            <Grid.Column width="14">
              <p className="desc-center">{fileDescription}</p>
            </Grid.Column>
          </Grid.Row>
          <Grid.Row centered>
            <Grid.Column width="10">
              <Dropzone onDrop={this.uploadFile} reset={this.state.reset} />
            </Grid.Column>
          </Grid.Row>
          <Grid.Row textAlign="center">
            <Grid.Column width="16">
              <Button
                className="yellow"
                size="medium"
                disabled={!this.state.enableSubmit}
                onClick={this.sendCodeToEmail}
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
        </Grid>
        <ConfirmModal
          open={this.state.confirmModal}
          onClose={() => this.setState({ confirmModal: false })}
        />
        <VerifyEmailModal
          open={verifyEmailModal}
          web_id={id}
          email={this.state.email}
          onVerifySuccess={this.handleUpload}
          onClose={() => this.setState({ verifyEmailModal: false })}
        />
      </RequestFormContainer>
    );
  }
}

export default withToastManager(Request);
