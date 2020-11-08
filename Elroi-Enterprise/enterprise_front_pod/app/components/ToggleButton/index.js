import React from 'react';
import styled from 'styled-components';
import { Button } from 'semantic-ui-react';

const Container = styled.div`
  .ui.button {
    border: 2px solid ${props=>`rgb(${props.fontColor.r},${props.fontColor.g},${props.fontColor.b},${props.fontColor.a})`};
    background: white;
    font-size: 17px;
    border-radius: 12px;
    letter-spacing: 5px;
    margin-right: 92px;
    width: 160px;
  }
  .ui.button.active {
    background-color: ${props=>`rgb(${props.fontColor.r},${props.fontColor.g},${props.fontColor.b},${props.fontColor.a})`};
    color: white;
  }
`;

class ToggleButton extends React.Component {
  state = {
    isActive: false,
  };
  render() {
    return (
      <Container fontColor={this.props.fontColor}>
        <Button
          active={this.state.isActive}
          onClick={() => this.setState({ isActive: true })}
        >
          YES
        </Button>
        <Button
          active={!this.state.isActive}
          onClick={() => this.setState({ isActive: false })}
        >
          NO
        </Button>
      </Container>
    );
  }
}

export default ToggleButton;
