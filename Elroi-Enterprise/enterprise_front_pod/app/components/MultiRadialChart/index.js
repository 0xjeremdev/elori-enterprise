import React from "react";
import ReactApexChart from "react-apexcharts";

class MultiRadialChart extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      series: [44, 55],
      options: {
        chart: {
          height: 320,
          type: "radialBar",
        },
        plotOptions: {
          radialBar: {
            dataLabels: {
              name: {
                fontSize: "12px",
              },
              value: {
                fontSize: "18px",
                formatter: function(val) {
                  return parseInt(val);
                },
              },
              total: {
                show: true,
                label: "Last Request Made",
                formatter: function(w) {
                  // By default this function returns the average of all series. The below is just an example to show the use of custom formatter function
                  return "8/21/20";
                },
              },
            },
          },
        },
        labels: ["# of Requests Made", "Confirmed Requests"],
      },
    };
  }

  render() {
    return (
      <div id="chart">
        <ReactApexChart
          options={this.state.options}
          series={this.state.series}
          type="radialBar"
          height={320}
        />
      </div>
    );
  }
}

export default MultiRadialChart;
