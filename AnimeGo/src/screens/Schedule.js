import React, { Component } from 'react';
import { View, FlatList, Text, Linking, Image, StyleSheet } from 'react-native';
import AnimeSchedule from '../core/AnimeSchedule';
import { ProgressBar } from '../components';
import { ACCENT_COLOUR } from '../value';
import { TouchableRipple, Card, CardContent, Title, Paragraph } from 'react-native-paper';

class Schedule extends Component {
  constructor() {
    super();
    this.state = {
      data: [], isReady: false, noAnime: false
    }
  }

  componentWillMount() {
    let schedule = new AnimeSchedule();
    schedule.getScheduleForToday().then((scheduleList) => {
      if (scheduleList == []) {
        this.setState({noAnime: true, isReady: true})
      } else {
        this.setState({data: scheduleList, isReady: true})
      }
    })
  }

  scheduleKey = (data) => data.name;
  render() {
    const { data, isReady, noAnime } = this.state;
    const { mainViewStyle, noAnimeStyle, textStyle, cellViewStyle, titleStyle, infoStyle, timeStyle, imageStyle } = styles;
    if (isReady == false) return <ProgressBar />
    else if (noAnime) {
      return (
        <View style={noAnimeStyle}>
          <Text style={textStyle}>No Anime today 0_0</Text>
        </View>
      )
    } else return (
      <View style={mainViewStyle}>
        <FlatList data={data} keyExtractor={this.scheduleKey} renderItem={({item}) => {
          return (
            <Card>
               <TouchableRipple onPress={() => Linking.openURL(item.link)}>
                <View style={{flexDirection: 'row', alignItems: 'center'}}>
                  <Image source={{uri: item.image}} style={imageStyle}/>
                  <CardContent>
                    <Title>{item.name}</Title>
                    <Paragraph>{item.time + ' ' + item.rating}</Paragraph>
                  </CardContent>
                </View>
              </TouchableRipple>
            </Card>
          )
        }} automaticallyAdjustContentInsets={false} showsVerticalScrollIndicator={false}
        ListHeaderComponent={<Text style={textStyle}>Data are from MyAnimeList</Text>} />
      </View>
    )
  }
}

const styles = StyleSheet.create({
  noAnimeStyle: {
    flex: 1,
    justifyContent: 'center'
  },
  mainViewStyle: {
    flex: 1
  },
  textStyle: {
    textAlign: 'center',
    color: ACCENT_COLOUR,
    fontSize: 16
  },
  cellViewStyle: {
    flex: 1,
    padding: 8
  },
  titleStyle: {
    textAlign: 'center',
    color: 'black',
    fontSize: 20
  },
  infoStyle: {
    textAlign: 'center'
  },
  timeStyle: {
    textAlign: 'center'
  },
  imageStyle: {
    width: 100,
    height: 145,
    alignSelf: 'center'
  }
})

export {Schedule};