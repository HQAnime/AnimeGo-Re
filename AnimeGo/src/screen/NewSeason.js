import React, { Component } from 'react';
import { AnimeList } from '../component/';
import { MajorLink } from '../value'; 

class NewSeason extends Component {
  render() {
    return (
      <AnimeList AnimeUrl={this.getNewSeason()}/>
    )
  }

  /**
   * Getting new season url depending on month
   */
  getNewSeason() {
    let now = new Date();
    var season = ''; 
    // Month starts from 0
    switch (now.getMonth() + 1) {
      case 1:
      case 2:
      case 3: season = 'winter'; break;
      case 4:
      case 5:
      case 6: season = 'spring'; break;
      case 7:
      case 8:
      case 9: season = 'summer'; break;
      case 10:
      case 11:
      case 12: season = 'fall'; break;
    }
    let url = MajorLink.NewSeason + season + '-' + now.getFullYear() + '-anime&page=';
    console.log(url);
    return url;
  }
}

export {NewSeason};