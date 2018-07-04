import React, { Component } from 'react';
import { AnimeList } from '../components';

class SubCategory extends Component {
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

export {SubCategory};