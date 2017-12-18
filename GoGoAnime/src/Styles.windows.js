import { Platform } from 'react-native';

export const Colour = {
  // Some colours
  GoGoAnimeOrange: '#f5c249',
  GoGoAnimeBlack: '#1b1b1b',
  GoGoAnimeBlue: '#03A9F4',
  GoGoAnimeRed: '#FF6D6B',
  GoGoAnimeGreen: '#2CCC90',
}

export const MainScreenStyles = {
  tabBarStyle: {
    backgroundColor: Colour.GoGoAnimeOrange,
  },
  tabStyle: {
    height: 40,
    padding: 0,
    backgroundColor: 'transparent',
  },
  indicatorStyle: {
    backgroundColor: 'white',
  },
}

export const RecentReleaseStyles = {
  loadingStyle: {
    padding: 10,
  },
}

export const WatchAnimeStyles = {
  loadingStyle: {
    padding: 10,
  },
}

export const NavigationStyles = {
  titleStyle: {
    width: '90%',
  },
  mainNavBarStyle: {
    backgroundColor: '#1b1b1b',
    justifyContent: 'center',
    elevation: 0,
  },
  searchNavBarStyle: {
    backgroundColor: '#1b1b1b',
  }
}

export const WindowsButtonStyles = {
  buttonStyle: {
    height: 30,
    padding: 0,
    margin: 0,
  }
}