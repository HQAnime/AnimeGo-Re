import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { GoGoAnime } from '../Constant';

class GenreDetail extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={GoGoAnime.Genre + this.props.genre}/>
    );
  }
}

export { GenreDetail };