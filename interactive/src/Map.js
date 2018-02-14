import React from 'react'
import PropTypes from 'prop-types'
import map from 'lodash/map';
import fromPairs from 'lodash/fromPairs';

import tas from './map.json';

const scale = ["#00441b","#1b7837","#5aae61","#a6dba0","#d9f0d3","#f7f7f7","#e7d4e8","#c2a5cf","#9970ab","#762a83","#40004b"];

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
  }else if (rank <= 33) {
    col = 6;
  }else if (rank <= 42) {
    col = 7;
  }else if (rank <= 51) {
    col = 8;
  }else if (rank <= 59) {
    col = 9;
  }else if (rank <= 64) {
    col = 10;
  }
  return scale[col];
}

const Map = ({ranking}) => {
  const ranks = fromPairs(map(ranking, (d,i) => ([d.name, i])))
  return (
    <div className="map">
      <svg width="400" height="600" viewBox="0 -14463 10019 14463">
        {tas.map(({geom, name}) => {
          return (
          <path key={name} d={geom} fill={colorMap(ranks[name])}/>
        )})}
      </svg>
    </div>
  );
}

Map.propTypes = {
  ranking: PropTypes.array.isRequired,
}

export default Map;
