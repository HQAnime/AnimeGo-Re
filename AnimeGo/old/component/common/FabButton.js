import React from 'react';
import ActionButton from 'react-native-action-button';
import { Icon } from 'react-native-elements';
import { Actions } from 'react-native-router-flux';
import { SecondaryColour } from '../../value';

const FabButton = () => {
  return (
    <ActionButton renderIcon={() => <Icon name='md-search' type='ionicon' color='white'/>}
      buttonColor={SecondaryColour} fixNativeFeedbackRadius onPress={() => Actions.SearchAnime()}/>
  )
}

export {FabButton};