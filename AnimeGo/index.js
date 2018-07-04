import React from 'react';
import { AppRegistry } from 'react-native';
import { DefaultTheme, Provider } from 'react-native-paper';
import App from './src/App';
import './src/Global';

// Theme for AnimeGo
const theme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    primary: '#FF9800',
    accent: '#448AFF',
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
