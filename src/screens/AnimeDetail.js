import React, { Component } from 'react';
import { Image, ActivityIndicator, ScrollView, View, Text, Alert } from 'react-native';
import { Card } from 'react-native-elements';
import AnimeDetailLoader from '../core/AnimeDetailLoader';
import { Actions } from 'react-native-router-flux';

class AnimeDetail extends Component {

  constructor(props) {
    super(props);
    this.link = this.props.link;
    this.state = {
      name: '', type: '', typeLink: '',
      genre: '', release: '',
      plot: '', image: '',
    }
  }

  componentWillMount() {
    this.loadInformation();
  }

  render() {
    if (this.state.name == '') {
      return (
        <View>
          <ActivityIndicator size='large'/>
        </View>
      )
    } else {
      return this.renderAnimeInfo();
    }
  }

  renderAnimeInfo() {
    return (
      <ScrollView>
        <Card title={this.state.name} image={{uri: this.state.image}}>
          <Text>{this.state.type}</Text>
          <Text>{this.state.genre}</Text>
          <Text>{this.state.release}</Text>
          <Text>{this.state.plot}</Text>
        </Card>
      </ScrollView>
    )
  }

  loadInformation = () => {
    let loader = new AnimeDetailLoader(this.link);
    loader.loadInformation()
    .then((animeInfo) => {
      if (animeInfo.length == {}) return;

      Actions.refresh({title: animeInfo.status})
      this.setState({
        name: animeInfo.name, type: animeInfo.type, typeLink: animeInfo.typeLink,
        genre: animeInfo.genre, release: animeInfo.release,
        plot: animeInfo.plot, image: animeInfo.image,
      });
    })
    .catch((error) => {
      console.error(error);
    });
  }
}

export { AnimeDetail };