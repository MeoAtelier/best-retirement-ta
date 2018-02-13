import React, { Component } from 'react';
import './App.css';
import Ranking from './Ranking';
import ranking from './ranking-data.json';

class App extends Component {
  render() {
    return (
      <div className="App">
        <Ranking ranking={ranking} />
      </div>
    );
  }
}

export default App;
