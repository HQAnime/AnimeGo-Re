import React from 'react';
import ActionButton from 'react-native-action-button';
import { Icon } from 'react-native-elements';
import { SecondaryColour } from '../../value';

const FabButton = () => {
  return (
    <ActionButton renderIcon={() => <Icon name='md-search' type='ionicon' color='white'/>}
      buttonColor={SecondaryColour} fixNativeFeedbackRadius/>
  )
}

export {FabButton};