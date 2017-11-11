import React, { Component } from 'react';
import { View, Text, FlatList, ActivityIndicator, Dimensions } from 'react-native';
import AnimeSourceLoader from '../core/AnimeSourceLoader';
import { Colour, WatchAnimeStyles } from '../Styles';
import SourceCell from './SourceCell';
import { LoadingIndicator } from '../component';

class SourceList extends Component {

  keyExtractor = (data) => data.source;

  constructor(props) {
    super(props);
    this.state = {
      data: [],
    }
  }

  componentWillMount() {
    let source = new AnimeSourceLoader(this.props.link);
    source.loadSource()
    .then((animeSource) => {
       console.log(animeSource);
      this.setState({
        data: animeSource,
      })  
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
      <View>
        <FlatList data={this.state.data} keyExtractor={this.keyExtractor}
          renderItem={({item}) => 
            <SourceCell data={item}/>
          } ListFooterComponent={
            <Text style={{padding: 20, textAlign: 'center'}}>Vidstreaming is recommended</Text>
          }/>
      </View>
    );
  }
}

const { loadingStyle } = WatchAnimeStyles;

export { SourceList };