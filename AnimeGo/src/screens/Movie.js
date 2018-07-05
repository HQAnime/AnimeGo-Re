import React, { Component } from 'react';
import { AnimeList } from '../components/';
import { MajorLink, GoGoAnime } from '../value'; 

class Movie extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={GoGoAnime + MajorLink.Movie}/>
    )
  }
}

export {Movie};