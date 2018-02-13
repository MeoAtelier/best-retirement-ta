import React, { Component } from 'react';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';

import './App.css';
import Ranking from './Ranking';
import Controls from './Controls';

import ranking from './ranking-data.json';

const weight = (ta, w) => (
  (ta.rates * w[0] + ta.sunshine * w[1] + ta.burglary * w[2] + ta.medical * w[3] + ta.population * w[4] + ta.property * w[5]) / 6
)



class App extends Component {
  state = {
    weights: [1,1,1,1,1,1],
    sorted: ranking,
  }

  changeWeight = (field, val) => {
    const weights = this.state.weights;
    weights[field] = val;
    this.setState({weights: weights})
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

  render() {
    const {weights,sorted} = this.state;
    return (
      <MuiThemeProvider>
        <div className="App">
          <Controls changeWeight={this.changeWeight} weights={weights} sortTAs={this.sortTAs} />
          <Ranking ranking={sorted} weights={weights} />
        </div>
      </MuiThemeProvider>
    );
  }
}

export default App;
