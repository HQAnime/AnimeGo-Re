import React, { Component } from 'react';
import { View, FlatList, Text, Linking, Image } from 'react-native';
import { styles } from './ScheduleStyles';
import AnimeSchedule from '../helper/core/AnimeSchedule';
import { LoadingIndicator, SmartTouchable } from '../component';

export default class Schedule extends Component {
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
    if (isReady == false) return <LoadingIndicator />
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
            <View style={cellViewStyle}>
              <SmartTouchable onPress={() => Linking.openURL(item.link)}>
                <View>
                  { global.dataSaver == true ? null : <Image source={{uri: item.image}} style={imageStyle} resizeMode='cover'/> }
                  <Text style={titleStyle}>{item.name}</Text>
                  <Text style={timeStyle}>{item.time + ' ' + item.rating }</Text>
                </View>
              </SmartTouchable>
            </View>
          )
        }} automaticallyAdjustContentInsets={false} showsVerticalScrollIndicator={false}
        ListHeaderComponent={<Text style={textStyle}>Data are from MyAnimeList</Text>} />
      </View>
    )
  }
}