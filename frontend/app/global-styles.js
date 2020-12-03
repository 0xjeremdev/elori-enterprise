import { createGlobalStyle } from 'styled-components';
import PoppinsBoldTtf from './assets/fonts/Poppins-Bold.ttf';
import PoppinsRegularTtf from './assets/fonts/Poppins-Regular.ttf';
import PoppinsLightTtf from './assets/fonts/Poppins-Light.ttf';
import AvenirNextDemiBoldTtf from './assets/fonts/AvenirNext-DemiBold.ttf';

const GlobalStyle = createGlobalStyle`
  html,
  body {
    height: 100%;
    width: 100%;
    background-image: url('https://images.unsplash.com/photo-1446080501695-8e929f879f2b?fit=crop&fm=jpg&h=725&ixjsv=2.0.0&ixlib=rb-0.3.5&q=80&w=1225');
    background-size: cover;
    background-attachment:fixed;
  }

  @font-face {
    font-family: "Poppins Bold";
    src: url('${PoppinsBoldTtf}') format("truetype");
  }      
  @font-face {
    font-family: "Poppins";
    src: url('${PoppinsRegularTtf}') format("truetype");
  }
  @font-face {
    font-family: "Poppins Light";
    src: url('${PoppinsLightTtf}') format("truetype");
  }
  @font-face {
    font-family: "AvenirNext-DemiBold";
    src: url('${AvenirNextDemiBoldTtf}') format("truetype");
  }
  
  body {
    font-family: Helvetica, Arial, sans-serif;
  }

  body.fontLoaded {
    font-family: 'Poppins', 'Open Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  }

  td{
    color: #717171;
  }

  #app {
    background-color: #fff;
    min-height: 100%;
    min-width: 100%;
  }

  p,
  label {
    line-height: 1.5em;
  }
`;

export default GlobalStyle;
