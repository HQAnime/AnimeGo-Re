import React, { Component } from 'react';
import { Image, ActivityIndicator, ScrollView, View, Text, Dimensions } from 'react-native';
import { Card } from 'react-native-elements';
import AnimeDetailLoader from '../core/AnimeDetailLoader';
import { Actions } from 'react-native-router-flux';

var width = Dimensions.get('screen').width / 2;

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
        <Card title={this.state.name}>
          <View style={{flexDirection: 'row', height: width * 1.429}}>
            <View style={{flex: 0.5}}>
              <Image source={{uri: this.state.image}} resizeMode='cover' style={{flex: 1}}/>
            </View>
            <View style={{flex: 0.5, justifyContent: 'space-around'}}>
              <Text style={styles.centerText}>{'Category:\n' + this.state.type}</Text>
              <Text style={styles.centerText}>{'Genre:\n' + this.state.genre}</Text>
              <Text style={styles.centerText}>{'Release:\n' + this.state.release}</Text>
            </View>
          </View>
          <Text>{'\n' + this.state.plot}</Text>
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

const styles = {
  centerText: {
    textAlign: 'center',
  }
}

export { AnimeDetail };