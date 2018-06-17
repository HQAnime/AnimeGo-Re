import React, { Component } from 'react';
import { AnimeList } from '../component';
import { MajorLink } from '../value';

export default class GenreInfo extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={global.domain + MajorLink.Genre + this.props.genre} showFab={false}/>
    );
  }
}