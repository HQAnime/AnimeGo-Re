import React from 'react';
import { View, ActivityIndicator, Text, Platform } from 'react-native';
import { AnimeGoColour } from '../../value';

const LoadingIndicator = () => {
  return (
    <View style={Platform.OS == 'ios' ? {justifyContent: 'center'} : null}>
      <ActivityIndicator color={AnimeGoColour} style={{padding: 10}} size='large'/>
    </View>
  )
}

export {LoadingIndicator};