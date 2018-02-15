import React, { Component } from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import getMuiTheme from 'material-ui/styles/getMuiTheme'


import ReactResizeDetector from 'react-resize-detector';

import './App.css';
import Ranking from './Ranking';
import Controls from './Controls';
import Map from './Map';
import Popup from './Popup';

import ranking from './ranking-data.json';
import detail from './values.json';


const muiTheme = getMuiTheme({
  slider: {
    selectionColor: '#111',
    trackColor: '#444'
  }
});

const weight = (ta, w) => (
  (ta.rates * w[0] + ta.sunshine * w[1] + ta.burglary * w[2] + ta.medical * w[3] + ta.population * w[4] + ta.property * w[5]) / 6
)



class App extends Component {
  state = {
    weights: [1,1,1,1,1,1],
    sorted: ranking,
    gridWidth: 6,
    width: 320,
    active: -1,
    selected: null
  }

  _onResize = w => {
    this.setState({gridWidth: Math.floor(w/(260*0.6)), width: w});
  }

  changeWeight = (field, val) => {
    const weights = this.state.weights;
    weights[field] = val;
    this.setState({weights: weights})
  }

  activeSlider = a => {
    this.setState({active: a})
  }

  sortTAs = () => {
    const { weights } = this.state;
    this.setState({sorted: ranking.sort((a,b) => {
      const oA = weight(a, weights);
      const oB = weight(b, weights);
      if (oA <oB) {
        return -1;
      } else if (oA > oB) {
        return 1;
      }
      return 0;
      })});
  }

  showDetail = area => {
    this.setState({selected: detail[area]});
  }

  hideDetail = () => {
    this.setState({selected: null});
  }

  render() {
    const {weights, sorted, gridWidth,width,active,selected} = this.state;
    return (
      <MuiThemeProvider muiTheme={muiTheme}>
        <div className="App">
          <div className="first-section">
            <div className="intro">
              <p style={{fontWeight: "700"}}>The following datasets were used to the identify the best place to retire in New Zealand.</p>
                <ul>
                  <li>Average rates paid in 2016  </li>
                  <li>Burglaries per capita in 2017 </li>
                  <li>The cost and availability of 2 bedroom properties in 2017 </li>
                  <li>The proportion and size of the population that is over 65 </li>
                  <li>The average annual sunshine between 1973 and 2013 </li>
                  <li>The number of DHB staff per capita </li>
                </ul>
              <p>Each area was ranked according to these criteria and then the average rank across the six criteria was used to calculate the overall rank.</p>
              <p>The overall ranks are shown on the map, and the flower-like visual shows how each area ranked across the six categories.</p>
              <p>Use the sliders to increase or decrease the importance of a category and see how the rankings change.</p>
              <p>A a full article is <a href="http://www.nzherald.co.nz/business/news/article.cfm?c_id=3&objectid=11992596">here</a>. Original data and details of the analysis are available <a href="http://insights.nzherald.co.nz/data/best-retirement-area/index.html">here</a>.</p>
            </div>
            <Map ranking={sorted} width={width} showDetail={this.showDetail} />
          </div>
          <Controls
            changeWeight={this.changeWeight}
            weights={weights}
            active={active}
            activeSlider={this.activeSlider}
            sortTAs={this.sortTAs} />
          <Ranking ranking={sorted} weights={weights} gridWidth={gridWidth} showDetail={this.showDetail} />
          <Popup selected={selected} hideDetail={this.hideDetail} />
          <ReactResizeDetector handleWidth onResize={this._onResize} />
        </div>
      </MuiThemeProvider>
    );
  }
}

export default App;
