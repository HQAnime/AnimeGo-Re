import React, { Component } from 'react';
import { AnimeList } from '../components';
import { MajorLink, GoGoAnime } from '../value';

class GenreInfo extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={GoGoAnime + MajorLink.Genre + this.props.genre}/>
    );
  }
}

export {GenreInfo};