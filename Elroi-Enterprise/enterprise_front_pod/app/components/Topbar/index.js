import React from "react";
import { Grid, Icon, Image } from "semantic-ui-react";
import userAvatar from "../../assets/images/user-sm.png";

class Topbar extends React.Component {
  render() {
    return (
      <Grid
        verticalAlign="middle"
        container
        style={{ justifyContent: "flex-end", marginTop: "10px" }}
      >
        <Grid.Row textAlign="left">
          <Grid.Column>
            <span>
              <Icon
                name={"bell outline"}
                size="big"
                style={{ color: "#ccc" }}
              />
            </span>
          </Grid.Column>
          <Grid.Column>
            <span>
              <Image src={userAvatar} />
            </span>
          </Grid.Column>
        </Grid.Row>
      </Grid>
    );
  }
}

export default Topbar;
