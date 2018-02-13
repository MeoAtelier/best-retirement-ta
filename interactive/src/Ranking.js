import React from 'react'
import PropTypes from 'prop-types'

const scale = (angle, val) => `rotate(${angle}),scale(${val},${val})`

const petal = (color, angle, val) => (
  <g transform={scale(angle,1 - val/100)}>
    <path fill={color} d="M -12 -100 C -12 -120, 12 -120, 12 -100"/>
    <path fill={color} d="M -12 -101 C -12 20, 12 20, 12 -101"/>
  </g>
)

const flower = ({property, rates, burglary, name, sunshine, medical, population}, i) => (
  <g key={name} transform={`scale(0.6,0.6),translate(${(i % 6) * 260 + 120},${300 * Math.floor(i/6) + 150})`}>
    {petal("#7F2222", 0, rates)}
    {petal("#A05D43", 60, sunshine)}
    {petal("#F3F396", 120, burglary)}
    {petal("#98DA7D", 180, medical)}
    {petal("#5188AE", 240, population)}
    {petal("#172074", 300, property)}
    <circle cx="0" cy="0" r="15" fill="#CCC" />
    <text x="0" y="140" textAnchor="middle" fontSize="20px">{name}</text>
  </g>
)

const Ranking = ({ ranking }) => {
  return (
  <div className="ranking">
    <svg width="960" height="2000">
      {ranking.map(flower)}
    </svg>
  </div>
)}

Ranking.propTypes = {
  ranking: PropTypes.array.isRequired
}

export default Ranking
