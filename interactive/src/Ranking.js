import React from 'react'
import PropTypes from 'prop-types'

const scale = (angle, val) => `rotate(${angle}),scale(${val},${val})`

const petal = (color, angle, val, w) => {
  return (
  <g transform={scale(angle,Math.max(0, 1 - (val / w)/100))}>
    <path fill={color} d="M -12 -100 C -12 -120, 12 -120, 12 -100"/>
    <path fill={color} d="M -12 -101 C -12 20, 12 20, 12 -101"/>
  </g>
)}

const flower = ({property, rates, burglary, name, sunshine, medical, population}, w, i) => (
  <g key={name} transform={`scale(0.6,0.6),translate(${(i % 6) * 260 + 120},${300 * Math.floor(i/6) + 150})`}>
    {petal("#7F2222", 0, rates, w[0])}
    {petal("#A05D43", 60, sunshine, w[1])}
    {petal("#F3F396", 120, burglary, w[2])}
    {petal("#98DA7D", 180, medical, w[3])}
    {petal("#5188AE", 240, population, w[4])}
    {petal("#172074", 300, property, w[5])}
    <circle cx="0" cy="0" r="15" fill="#CCC" />
    <text x="0" y="140" textAnchor="middle" fontSize="20px">{name}</text>
  </g>
)

const Ranking = ({ ranking, weights }) => {
  return (
  <div className="ranking">
    <svg width="960" height="2000">
      {ranking.map((r,i) => flower(r, weights, i))}
    </svg>
  </div>
)}

Ranking.propTypes = {
  ranking: PropTypes.array.isRequired,
  weights: PropTypes.array.isRequired
}

export default Ranking
