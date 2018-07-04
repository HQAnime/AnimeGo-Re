import React from 'react';
import { AppRegistry } from 'react-native';
import { DefaultTheme, Provider } from 'react-native-paper';
import App from './src/app';
import './src/global';
import { PRIMARY_COLOUR, ACCENT_COLOUR } from './src/value';

// Theme for AnimeGo
const theme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    primary: PRIMARY_COLOUR,
    accent: ACCENT_COLOUR,
  },
}

export default function AnimeGo() {
  return (
    <Provider theme={theme}>
      <App />
    </Provider>
  );
}

AppRegistry.registerComponent('AnimeGo', () => AnimeGo);
