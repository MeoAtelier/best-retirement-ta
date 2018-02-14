import React from 'react'
import PropTypes from 'prop-types'
import Slider from 'material-ui/Slider';

import './Controls.css';


const colors = [ "#7F2222", "#F3F396", "#A05D43", "#98DA7D", "#5188AE", "#172074" ];
const labels = [ "Low rates", "High sunshine", "Low burglary", "Medical staff",
"Population over 65",
"Two bedroom properties" ];

const Controls = ({ changeWeight, weights, sortTAs, active, activeSlider }) => (
  <div className="controls">
    <div className="labels">
      {labels.map((l,i) => (
        <div className="control-wrapper" key={l}>
          <div className={active === i ? "active" : ""}>{l}</div>
        </div>))}
      </div>
    <div className="sliders-header">More Important</div>
      <div className="sliders">
        {weights.map((w,i) => (
          <div key={i} >
            <div className={"slider-wrapper"}
              style={{backgroundColor: colors[i]}}>
              <Slider
                sliderStyle={{selectionColor: colors[i]}}
                axis="y"
                min={0}
                max={2}
                value={w}
                onDragStop={sortTAs}
                onDragStart={() => activeSlider(i)}
                onChange={(e,v) => changeWeight(i, v)}
              />
            </div>
          </div>
        ))}
      </div>
      <div className="sliders-footer">Less Important</div>
    </div>

)

Controls.propTypes = {
  changeWeight: PropTypes.func.isRequired,
  sortTAs: PropTypes.func.isRequired,
  activeSlider: PropTypes.func.isRequired,
  active: PropTypes.number.isRequired,
  weights: PropTypes.array.isRequired
}

export default Controls
