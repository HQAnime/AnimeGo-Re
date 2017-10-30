import { registerScreens } from './src/screens';
import { Navigation } from 'react-native-navigation';

const App = () => {
  // Register all screens here
  registerScreens();
  
  Navigation.startTabBasedApp({
    tabs: [
      {
        label: 'RecentRelease',
        screen: 'gogoanime.RecentRelease',
        title: 'RecentRelease'
      },
      {
        label: 'NewSeason',
        screen: 'gogoanime.NewSeason',
        title: 'NewSeason'
      },
      {
        label: 'Genre',
        screen: 'gogoanime.Genre',
        title: 'Genre'
      }
    ],
  });
}

export default App;