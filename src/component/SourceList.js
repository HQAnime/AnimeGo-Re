import React, { Component } from 'react';
import { View, Text, FlatList, Button, ActivityIndicator, Dimensions } from 'react-native';
import AnimeSourceLoader from '../core/AnimeSourceLoader';
import { Colour } from '../Styles';
import SourceCell from './SourceCell';
import { LoadingIndicator } from '../component';
import { Actions } from 'react-native-router-flux';

class SourceList extends Component {

  keyExtractor = (data) => data.source;

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      name: '', link: '',
    }
  }

  componentWillMount() {
    let source = new AnimeSourceLoader(this.props.link);
    source.loadSource()
    .then((animeSource) => {
      // console.log(animeSource);
      if (animeSource.length == 0) return;
      this.setState({
        data: animeSource,
        name: animeSource[1].animeName,
        link: animeSource[1].infoLink,
      })  
    })
    .catch((error) => {
      console.error(error);
    });
  }

  render() {
    /* A loading indictor */
    if (this.state.data.length == 0) {
      return (
        <LoadingIndicator />
      )
    }

    return (
      <View style={{flex: 1}}>
        <FlatList data={this.state.data} keyExtractor={this.keyExtractor}
          renderItem={({item}) => 
            <SourceCell data={item}/>
          } ListHeaderComponent={this.renderHeader}/>
      </View>
    );
  }

  renderHeader = () => {
    return (
      <View style={{padding: 8}}>
        <Button title={this.state.name} color={Colour.GoGoAnimeBlue}
        onPress={this.infoBtnPressed}/>
      </View>
    )
  }

  infoBtnPressed = () => {
    // In case user wants infinite loop
    if (this.props.fromInfo) Actions.pop();
    else Actions.AnimeDetail({title: this.state.name, link: this.state.link});
  }
}

export { SourceList };