import React, { Component } from 'react';
import { AnimeList } from '../components/';
import { MajorLink, GoGoAnime } from '../value'; 

class Popular extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={GoGoAnime + MajorLink.Popular}/>
    )
  }
}

export {Popular};