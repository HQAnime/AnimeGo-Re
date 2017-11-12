import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { GoGoAnime } from '../Constant';

class Popular extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={GoGoAnime.Popular}/>
    );
  }
}

export { Popular };