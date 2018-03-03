import React, { Component } from 'react';
import { AnimeList } from '../component';
import { MajorLink } from '../value';

class GenreInfo extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={MajorLink.Genre + this.props.genre}/>
    );
  }
}

export {GenreInfo};