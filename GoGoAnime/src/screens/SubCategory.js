import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { GoGoAnime } from '../Constant';

class SubCategory extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={this.props.link}/>
    )
  }
}

export { SubCategory };