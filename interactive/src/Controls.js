import React from 'react'
import PropTypes from 'prop-types'
import Slider from 'material-ui/Slider';

import './Controls.css';

const Controls = ({ changeWeight, weights, sortTAs }) => (
  <div className="controls">
    {weights.map((w,i) => (
      <Slider
        key={i}
        axis="y"
        min={0}
        max={2}
        value={w}
        onDragStop={sortTAs}
        onChange={(e,v) => changeWeight(i, v)}
      />
    ))}
  </div>
  
)

Controls.propTypes = {
  changeWeight: PropTypes.func.isRequired,
  sortTAs: PropTypes.func.isRequired,
  weights: PropTypes.array.isRequired
}

export default Controls
