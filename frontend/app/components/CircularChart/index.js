import React from "react";
import ReactApexChart from "react-apexcharts";

class CircularChart extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      options: {
        chart: {
          height: 320,
          type: "radialBar",
        },
        plotOptions: {
          radialBar: {
            startAngle: -135,
            endAngle: 225,
            hollow: {
              margin: 0,
              size: "70%",
              background: "#fff",
              image: undefined,
              imageOffsetX: 0,
              imageOffsetY: 0,
              position: "front",
              dropShadow: {
                enabled: true,
                top: 3,
                left: 0,
                blur: 4,
                opacity: 0.24,
              },
            },
            track: {
              background: "#fff",
              strokeWidth: "67%",
              margin: 0, // margin is in pixels
              dropShadow: {
                enabled: true,
                top: -3,
                left: 0,
                blur: 4,
                opacity: 0.35,
              },
            },

            dataLabels: {
              show: true,
              name: {
                offsetY: -10,
                show: true,
                color: "#888",
                fontSize: "17px",
              },
              value: {
                formatter: function(val) {
                  return parseInt(val) + "%";
                },
                color: "#111",
                fontSize: "36px",
                show: true,
              },
            },
          },
        },
        fill: {
          type: "gradient",
          gradient: {
            shade: "dark",
            type: "horizontal",
            shadeIntensity: 0.5,
            gradientToColors: ["#ABE5A1"],
            inverseColors: true,
            opacityFrom: 1,
            opacityTo: 1,
            stops: [0, 100],
          },
        },
        stroke: {
          lineCap: "round",
        },
        labels: ["0/0 approved"],
      },
    };
  }

  componentDidUpdate(prevPros) {
    const { total, validCount } = this.props;
    if (total !== prevPros.total || validCount !== prevPros.validCount) {
      const label = `${this.props.validCount}/${this.props.total} approved`;
      this.setState({ options: { ...this.state.options, labels: [label] } });
    }
  }

  render() {
    const series = (this.props.validCount / this.props.total) * 100;
    return (
      <div id="chart">
        <ReactApexChart
          options={this.state.options}
          series={[series]}
          type="radialBar"
          height={320}
        />
      </div>
    );
  }
}

export default CircularChart;
