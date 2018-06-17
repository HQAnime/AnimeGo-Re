import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { MajorLink } from '../value'; 

export default class Popular extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={global.domain + MajorLink.Popular}/>
    )
  }
}