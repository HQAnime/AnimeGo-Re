import React, { PureComponent } from 'react';
import { SourceList } from '../component/';

class WatchAnime extends PureComponent {
  render() {
    const { link, fromInfo } = this.props;
    return (
      <SourceList link={link} fromInfo={fromInfo}/>
    );
  }
}

export { WatchAnime };