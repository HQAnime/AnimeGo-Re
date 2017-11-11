import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { GoGoAnime } from '../Constant';

class RecentRelease extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={GoGoAnime.NewRelease}/>
    )
  }
}

export { RecentRelease };