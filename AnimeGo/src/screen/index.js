import { Navigation } from 'react-native-navigation';

import AnimeDetail from './AnimeDetail';
import Genre from './Genre';
import GenreInfo from './GenreInfo';
import Movie from './Movie';
import NewRelease from './NewRelease';
import NewSeason from './NewSeason';
import Popular from './Popular';
import Schedule from './Schedule';
import SearchAnime from './SearchAnime';
import Setting from './Setting';
import SubCategory from './SubCategory';
import ToWatch from './ToWatch';
import WatchAnime from './WatchAnime';
import Drawer from './Drawer';

export function setupScreen() {
  Navigation.registerComponent('go.anime.detail', () => AnimeDetail);
  Navigation.registerComponent('go.genre', () => Genre);
  Navigation.registerComponent('go.genre.info', () => GenreInfo);
  Navigation.registerComponent('go.movie', () => Movie);
  Navigation.registerComponent('go.new.release', () => NewRelease);
  Navigation.registerComponent('go.new.season', () => NewSeason);
  Navigation.registerComponent('go.popular', () => Popular);
  Navigation.registerComponent('go.schedule', () => Schedule);
  Navigation.registerComponent('go.search.anime', () => SearchAnime);
  Navigation.registerComponent('go.settings', () => Setting);
  Navigation.registerComponent('go.sub.category', () => SubCategory);
  Navigation.registerComponent('go.towatch', () => ToWatch);
  Navigation.registerComponent('go.watch.anime', () => WatchAnime);

  Navigation.registerComponent('go.drawer', () => Drawer);
}