import React, { PureComponent } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { SmartTouchable } from '../../components';
import { SecondaryColour } from '../../value';
import { Actions } from 'react-native-router-flux';

class GenreCell extends PureComponent {
  constructor(props) {
    super();
    this.flex = 1 / props.column;
    this.title = props.data;
  }

  render() {
    const { viewStyle, textStyle } = styles;  
    return (
      <View style={{flex: this.flex}}>
        <SmartTouchable onPress={this.showGenreInfo} round>
          <View style={viewStyle}>
            <Text style={textStyle}>{this.title}</Text>
          </View>
        </SmartTouchable>
      </View>
    )
  }

  showGenreInfo = () => {
    let genre = this.title.split(' ').join('-') + '?page=';
    // console.log(title, genre);
    Actions.GenreInfo({title: this.title, genre: genre, headerTintColor: 'white'});
  }
}

const styles = StyleSheet.create({
  viewStyle: {
    justifyContent: 'center',
    margin: 4, 
    padding: 4,
    height: 44,    
    flex: 1,
    backgroundColor: SecondaryColour,
    borderRadius: 22,        
  },
  textStyle: {
    color: 'white',
    fontWeight: 'bold',
    textAlign: 'center',
  }
})

export { GenreCell };