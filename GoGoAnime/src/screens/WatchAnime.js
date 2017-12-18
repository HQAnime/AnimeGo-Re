import React, { Component } from 'react';
import { View, Text } from 'react-native';
import { SourceList } from '../component/';

class WatchAnime extends Component {
  render() {
    return (
      <SourceList link={this.props.link} fromInfo={this.props.fromInfo}/>
    );
  }
}

export { WatchAnime };