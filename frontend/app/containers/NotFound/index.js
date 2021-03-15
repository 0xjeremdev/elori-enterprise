import React from "react";
import { Button, Grid, Icon, Segment } from "semantic-ui-react";
import backImg from "../../assets/images/grey-back.jpg";
const NotFound = () => {
  return (
    <Grid verticalAlign="middle">
      <Grid.Row textAlign="center">
        <Grid.Column>
          <Segment
            style={{
              height: "40vw",
              backgroundImage: `url(${backImg})`,
              backgroundPosition: "center",
            }}
          >
            <br />
            <br />
            <br />
            <br />
            <br />
            <h1>Feature Coming Soon</h1>
            <br />
            <br />
            <br />
          </Segment>
        </Grid.Column>
      </Grid.Row>
    </Grid>
  );
};

export default NotFound;
