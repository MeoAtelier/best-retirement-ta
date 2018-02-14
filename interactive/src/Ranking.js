import React from 'react'
import PropTypes from 'prop-types'
import Animate from 'react-move/Animate';
import { easeExpOut } from 'd3-ease';

const scale = (angle, val) => `rotate(${angle}),scale(${val},${val})`

const petal = (color, angle, val, w) => {
  return (
  <g transform={scale(angle,Math.max(0, 1 - (val / w)/100))}>
    <path fill={color} d="M -12 -100 C -12 -120, 12 -120, 12 -100"/>
    <path fill={color} d="M -12 -101 C -12 20, 12 20, 12 -101"/>
  </g>
)}

const flower = ({property, rates, burglary, name, sunshine, medical, population}, w, gridWidth, i) => {
  const x0 = (i % gridWidth) * 260 + 120;
  const y0 = 300 * Math.floor(i/gridWidth) + 150;
  return (
    <Animate key={name}
      start={() => ({x:x0, y:y0})}
      update={() => ({x:[x0], y:[y0], timing: {ease: easeExpOut, duration:2000 }})}
    >
      {({x,y}) => (
    <g transform={`scale(0.6,0.6),translate(${x},${y})`}>
      {petal("#7F2222", 0, rates, w[0])}
      {petal("#F3F396", 60, sunshine, w[1])}
      {petal("#A05D43", 120, burglary, w[2])}
      {petal("#98DA7D", 180, medical, w[3])}
      {petal("#5188AE", 240, population, w[4])}
      {petal("#172074", 300, property, w[5])}
      <circle cx="0" cy="0" r="15" fill="#AAA" />
      <text x="0" y="140" textAnchor="middle" fontSize="20px">{name}</text>
    </g>)}
  </Animate>
)}

const Ranking = ({ ranking, weights, gridWidth }) => {
  return (
  <div className="ranking">
    <svg width={gridWidth * (260 * 0.6)} height={Math.ceil(66/gridWidth) * (300*0.6)}>
      {ranking.map((r,i) => flower(r, weights, gridWidth, i))}
    </svg>
  </div>
)}

Ranking.propTypes = {
  ranking: PropTypes.array.isRequired,
  weights: PropTypes.array.isRequired,
  gridWidth: PropTypes.number.isRequired
}

export default Ranking
