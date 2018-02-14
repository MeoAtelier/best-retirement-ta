import React from 'react'
import PropTypes from 'prop-types'
import map from 'lodash/map';
import fromPairs from 'lodash/fromPairs';

import './Map.css';
import tas from './map.json';

const scale = ["#5e4fa2","#3288bd","#66c2a5","#abdda4","#e6f598","#fee08b","#fdae61","#f46d43","#d53e4f","#9e0142"];

const colorMap = rank => {
  let col;
  if (rank === 0) {
    col = 0;
  } else if (rank <= 5) {
    col = 1;
  }else if (rank <= 13) {
    col = 2;
  }else if (rank <= 22) {
    col = 3;
  }else if (rank <= 32) {
    col = 4;
  }else if (rank <= 42) {
    col = 5;
  }else if (rank <= 51) {
    col = 6;
  }else if (rank <= 59) {
    col = 7;
  }else if (rank <= 64) {
    col = 8;
  }else {
    col = 9;
  } 
  return scale[col];
}

const Map = ({ranking,width}) => {
  const ranks = fromPairs(map(ranking, (d,i) => ([d.name, i])))
  const w = Math.min(400,width);
  return (
    <div className="map">
      <svg width={w} height={w*1.5} viewBox="0 -14463 10019 14463">
        {tas.map(({geom, name}) => {
          return (
          <path key={name} d={geom} fill={colorMap(ranks[name])}/>
        )})}
      </svg>
      
      <div className="map-key">
        <div className="map-key-wrap">
        <div className="map-text">
          <div>Best</div>
          <div>Worst</div>
        </div>
        <div className="map-colors">
          {scale.map(c => (<div key={c} style={{backgroundColor: c, width: "36px", height: "15px"}} />))}
        </div>
        </div>
      </div>
    </div>
  );
}

Map.propTypes = {
  ranking: PropTypes.array.isRequired,
  width: PropTypes.number.isRequired
}

export default Map;
