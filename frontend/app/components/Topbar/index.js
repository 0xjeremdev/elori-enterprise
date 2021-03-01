import React from "react";
import { Grid, Icon, Image } from "semantic-ui-react";
import userAvatar from "../../assets/images/user-sm.png";
import noImage from "../../assets/images/no-img.png";

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
          </Grid.Column>
          <Grid.Column>
            <span>
              <Image src={this.props.avatarUrl?this.props.avatarUrl:noImage} />
            </span>
          </Grid.Column>
        </Grid.Row>
      </Grid>
    );
  }
}

export default Topbar;
