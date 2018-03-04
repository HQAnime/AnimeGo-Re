import React, { Component } from 'react';
import { AnimeList } from '../component';

class SubCategory extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={this.props.link} showFab={false}/>
    )
  }
}

export {SubCategory};