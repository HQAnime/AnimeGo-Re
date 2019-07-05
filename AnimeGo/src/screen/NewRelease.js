import React, { Component } from 'react';
import { MajorLink } from '../value';
import { AnimeList } from '../component/';

class NewRelease extends Component {
  render() {
    console.log(global.domain);
    return (
      <AnimeList AnimeUrl={global.domain + MajorLink.NewRelease}/>
    )
  }
}

export {NewRelease};