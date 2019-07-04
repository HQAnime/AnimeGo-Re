import React from 'react';
import { FAB } from 'react-native-paper';
import { Icon } from 'react-native-elements';
import { Actions } from 'react-native-router-flux';

const FabButton = () => {
  return (
    <FAB icon='search' style={{position: 'absolute', margin: 16, right: 0, bottom: 0}}
      onPress={() => Actions.SearchAnime()}/>
  )
}

export {FabButton};