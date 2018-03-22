import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { MajorLink } from '../value'; 

class Popular extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={MajorLink.Popular}/>
    )
  }
}

export {Popular};