import React from "react";
import { Grid } from "semantic-ui-react";

const NotFound = () => {
  return (
    <Grid verticalAlign="middle">
      <Grid.Row textAlign="center">
        <Grid.Column>
          <div class="middle">
            <br />
            <h1>COMING SOON</h1>
            <hr />
            <p>35 days left</p>
          </div>
        </Grid.Column>
      </Grid.Row>
    </Grid>
  );
};

export default NotFound;
