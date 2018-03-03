import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { MajorLink } from '../value'; 

class NewSeason extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={MajorLink.NewSeason}/>
    )
  }
}

export {NewSeason};