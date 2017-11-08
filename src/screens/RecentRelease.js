import React, { Component } from 'react';
import { ScrollView, View, Text, ActivityIndicator } from 'react-native';
import { GoGoAnime } from '../Constant';

class RecentRelease extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: ''
    };
  }

  componentWillMount() {
    // Loading data here
    fetch(GoGoAnime.NewRelease)
    .then((html) => html.text())
    .then((htmlText) => {
      var HTMLParser = require('fast-html-parser');
      
      var root = HTMLParser.parse(htmlText);
      var episodes = root.querySelector('.items');
      var newDataString = '';
      for (var i = 0; i < episodes.childNodes.length; i++) {
        var anime = episodes.childNodes[i];
        // Somehow, next line is parsed as well
        if (anime.isWhitespace) continue;
        var animeLink = GoGoAnime.MainURL + anime.querySelector('.img').childNodes[1].attributes.href;
        var animeName = anime.querySelector('.name').text;
        var animeEpisode = anime.querySelector('.episode').text;
        newDataString += animeName + '\n' + animeEpisode + '\n' + animeLink + '\n\n';
      }
      this.setState({
        data:newDataString
      })
    })
    .catch((error) => {
      console.error(error);
    });
  }

  render() {
    /* A loading indictor */
    if (this.state.data == '') {
      return (
        <View>
          <ActivityIndicator style={styles.loadingStyle} size='large'/>
        </View>
      )
    }

    return (
      <ScrollView>
        <Text>{this.state.data}</Text>
      </ScrollView>
    );
  }
}

const styles = {
  loadingStyle: {
    padding: 10,
  }
}

export { RecentRelease };