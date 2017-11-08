import React, { Component } from 'react';
import { Linking, TouchableOpacity, Image, FlatList, View, Text, ActivityIndicator } from 'react-native';
import { GoGoAnime } from '../Constant';

class RecentRelease extends Component {

  keyExtractor = (item, index) => item.id;

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      page: 1,
      hasMorePage: true
    };
  }

  componentWillMount() {
    this.loadAnime();
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
      <FlatList
        data={this.state.data} keyExtractor={item => item.name}
        renderItem={({item}) => 
        <View style={{padding: 10}}>
          <TouchableOpacity onPress={() => Linking.openURL(item.link).catch(err => console.error('An error occurred', err))}>
            <Text>{item.name}</Text>
            <Text>{item.episode}</Text>
            <Image source={{uri: item.thumbnail}} style={{width: 225, height: 326}} />
          </TouchableOpacity>
        </View>
        } onEndReached={this.loadAnime} onEndReachedThreshold={0}
        contentContainerStyle={{alignItems: 'center'}} ListFooterComponent={
          <ActivityIndicator style={styles.loadingStyle} size='large'/>
        }/>
    );
  }

  loadAnime = () => {
    if (!this.state.hasMorePage) return;
    // Loading data here
    console.log(GoGoAnime.NewRelease + this.state.page);
    fetch(GoGoAnime.NewRelease + this.state.page)
    .then((html) => html.text())
    .then((htmlText) => {
      var HTMLParser = require('fast-html-parser');
      
      var root = HTMLParser.parse(htmlText);
      var items = root.querySelector('.items').childNodes;
      var animeData = this.state.data;

      // In case last page is reached
      var length = items.length;
      if (length == 0) {
        this.setState({
          hasMorePage: false
        })
        return;
      } 

      for (var i = 0; i < length; i++) {
        var anime = items[i];
        // Somehow, next line is parsed as well
        if (anime.isWhitespace) continue;

        var animeImage = anime.querySelector('.img');
        var animeLink = GoGoAnime.MainURL + animeImage.childNodes[1].attributes.href;
        var animeName = anime.querySelector('.name').text;
        var animeEpisode = anime.querySelector('.episode').text;
        var animeThumbnail = animeImage.childNodes[1].childNodes[1].attributes.src;
        animeData.push({name: animeName, episode: animeEpisode, link: animeLink, thumbnail: animeThumbnail});
      }
      this.setState({
        data: animeData,
        // Preparing for loading for data
        page: this.state.page + 1
      })
    })
    .catch((error) => {
      console.error(error);
    });
  }
}

const styles = {
  loadingStyle: {
    padding: 10,
  }
}

export { RecentRelease };