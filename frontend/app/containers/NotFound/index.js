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
            <h1>We're Coming Soon</h1>
            <br />
            <br />
            <br />
            <p>
              There are many variations of passages of Loem fered alt
              <br />
              eration in some form, by injected even slightly believable.
            </p>
            <br />
            <br />
            <br />
            <Button color="violet" circular size="big">
              CONTACT US
            </Button>
            <br />
            <br />
            <br />
            <div>
              <Button circular color="facebook" icon="facebook" /> &nbsp;&nbsp;&nbsp;
              <Button circular color="twitter" icon="twitter" /> &nbsp;&nbsp;&nbsp;
              <Button circular color="linkedin" icon="linkedin" /> &nbsp;&nbsp;&nbsp;
              <Button circular color="instagram" icon="instagram" />
            </div>
          </Segment>
        </Grid.Column>
      </Grid.Row>
    </Grid>
  );
};

export default NotFound;
