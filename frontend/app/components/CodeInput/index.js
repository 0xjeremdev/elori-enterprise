import React, { Component } from 'react';
import ReactCodeInput, { reactCodeInput } from 'react-code-input';

const props = {
  className: reactCodeInput,
  inputStyle: {
    fontFamily: 'monospace',
    MozAppearance: 'textfield',
    boxShadow: '0px 2px 4px #ACACAC',
    border: '1px solid #ADADAD',
    margin: '4px',
    width: '50px',
    height: '80px',
    fontSize: '32px',
    color: 'black',
    backgroundColor: 'white',
    textAlign: 'center',
  },
  inputStyleInvalid: {
    fontFamily: 'monospace',
    MozAppearance: 'textfield',
    boxShadow: '0px 2px 4px #ACACAC',
    border: '1px solid rgb(238, 211, 215)',
    margin: '4px',
    width: '50px',
    height: '80px',
    fontSize: '32px',
    color: 'rgb(185, 74, 72)',
    backgroundColor: 'rgb(242, 222, 222)',
    textAlign: 'center',
  },
};

export default class CodeInput extends Component {

  render() {
    return (
      <ReactCodeInput
        onChange={(value) => this.props.onChange(value)}
        type="text"
        inputMode="numeric"
        fields={6}
        {...props}
      />
    );
  }
}
