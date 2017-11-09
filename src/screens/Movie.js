import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { GoGoAnime } from '../Constant';

class Movie extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={GoGoAnime.Movie}/>
    );
  }
}

export { Movie };