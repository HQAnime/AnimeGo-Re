import { Navigation } from 'react-native-navigation';

import RecentRelease from './RecentRelease';
import Genre from './Genre';
import NewSeason from './NewSeason';

// register all screens of the app (including internal ones)
export function registerScreens() {
  Navigation.registerComponent('gogoanime.RecentRelease', () => RecentRelease);
  Navigation.registerComponent('gogoanime.Genre', () => Genre);
  Navigation.registerComponent('gogoanime.NewSeason', () => NewSeason);
}