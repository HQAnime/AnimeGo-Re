import { AppRegistry } from 'react-native';
import * as React from 'react';
import './src/global';
import { DefaultTheme, Provider as PaperProvider } from 'react-native-paper';
import App from './src/app/App';
import { AnimeGoColour, BlueColour } from './src/value';

const theme = {
    ...DefaultTheme,
    roundness: 2,
    colors: {
      ...DefaultTheme.colors,
      primary: AnimeGoColour,
      accent: BlueColour,
    }
  };
  
  export default function Main() {
    return (
      <PaperProvider theme={theme}>
        <App />
      </PaperProvider>
    );
  }

AppRegistry.registerComponent('AnimeGo', () => Main);
