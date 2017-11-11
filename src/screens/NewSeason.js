import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { GoGoAnime } from '../Constant';

class NewSeason extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={GoGoAnime.NewSeason}/>
    );
  }
}

export { NewSeason };