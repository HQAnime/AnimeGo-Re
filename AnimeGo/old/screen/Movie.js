import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { MajorLink } from '../value'; 

class Movie extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={global.domain + MajorLink.Movie}/>
    )
  }
}

export {Movie};