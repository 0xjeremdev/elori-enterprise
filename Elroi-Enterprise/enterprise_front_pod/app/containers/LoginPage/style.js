import styled from 'styled-components';
import { Container } from 'semantic-ui-react';

export const PortalWrapper = styled(Container)`
  padding: 120px 0px;
  width: 350px !important;
  span.title {
    color: #252529;
    font-size: 25px;
    font-weight: 500;
    line-height: 38px;
    display: block;
  }
  span.input-label {
    color: #6b6c6f;
    display: block;
    padding: 0 0 10px 10px;
  }
  .ui.input input {
    width: 350px;
    border-radius: 20px;
  }
  .ui.input.left input {
    padding-left: 2.67142857em !important;
  }
  .ui.input.right input {
    padding-right: 2.67142857em !important;
  }
  .ui.input.left > i.icon {
    right: auto;
    left: 1px;
    border-radius: 0.28571429rem 0 0 0.28571429rem;
  }
  .ui.input.right > input + i.icon {
    right: 0;
    left: auto;
    cursor: pointer;
    border-radius: 0 0.28571429rem 0.28571429rem 0;
  }
  .ui.button.login {
    border-radius: 20px;
    background: linear-gradient(135deg, #fec871, #feb172);
    width: 160px;
    height: 40px;
    margin-right: 18px;
    color: #ffffff;
  }
  .ui.button.login.disabled {
    background: linear-gradient(135deg, #fec871, #feb172) !important;
  }
  .ui.remember-me label {
    color: #000000;
  }
  span.span-btn {
    color: #252529;
    cursor: pointer;
  }
  span.number {
    color: #04d68e;
  }
  span.error-msg {
    color: red; font-size: 12px; margin-left: 12px;
  }
`;