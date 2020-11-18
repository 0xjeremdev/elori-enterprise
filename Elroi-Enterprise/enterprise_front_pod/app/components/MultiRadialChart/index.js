import React from "react";
import ReactApexChart from "react-apexcharts";

class MultiRadialChart extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      total: 0,
      progress: 0,
      complete: 0,
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
                label: "0",
                formatter: function(w) {
                  // By default this function returns the average of all series. The below is just an example to show the use of custom formatter function
                  return `Total Valid`;
                },
              },
            },
          },
        },
        labels: ["# of Progress", "Completed Requests"],
      },
    };
  }

  componentDidUpdate(prevPros) {
    const { totalValidCount, progressCount, completeCount } = this.props;
    if (
      totalValidCount !== prevPros.totalValidCount ||
      progressCount !== prevPros.progressCount ||
      completeCount !== prevPros.completeCount
    ) {
      this.setState({
        ...this.state,
        total: totalValidCount,
        progress: progressCount,
        complete: completeCount,
        series: [progressCount, completeCount],
        options: {
          ...this.state.options,
          plotOptions: {
            ...this.state.options.plotOptions,
            radialBar: {
              ...this.state.options.plotOptions.radialBar,
              dataLabels: { ...this.state.options.plotOptions.radialBar.dataLabels, total: {
                ...this.state.options.plotOptions.radialBar.dataLabels.total, label: `${totalValidCount}`
              } },
            },
          },
        },
      });
    }
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
