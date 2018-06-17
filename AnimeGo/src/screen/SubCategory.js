import React, { Component } from 'react';
import { AnimeList } from '../component';

export default class SubCategory extends Component {
  componentWillUnmount() {
    // Reset thi value in case user wants to check it again
    global.currSubCategory = '';
  }

  render() {
    return (
      <AnimeList AnimeUrl={this.props.link} showFab={false}/>
    )
  }
}