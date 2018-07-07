/*
  value.js
  Created on 21 Feb 2018 
  by Yiheng Quan
  USED TO STORE CONSTANTS
*/

export const PRIMARY_COLOUR = '#FF9800';
export const ACCENT_COLOUR = '#448AFF';
export const GreyColour = '#607D8B';
export const RedColour = '#F44336';
export const GreenColour = '#4CAF50';

export const Github = 'https://github.com/HenryQuan/AnimeGo';
export const Release = 'https://github.com/HenryQuan/AnimeGo/releases/latest';
export const GoGoAnime = 'https://www3.gogoanime.se';
export const Email = 'mailto:development.henryquan@gmail.com';

export const VERSION = '1.1.0';

/**
 * Screen index for quick screen pushing
 */
export const ScreenIndex = {
  NewRelease: 0,
  NewSeason: 1,
  Movie: 2,
  Popular: 3,
  Genre: 4,
  Setting: 5,
  ToWatch: 6,
  Schedule: 7
}

/**
 * Some links for gogoanime
 */
export const MajorLink = {
  NewRelease: '/page-recent-release.html?page=',
  NewSeason: '/sub-category/',
  Movie: '/anime-movies.html?page=',
  Genre: '/genre/',
  Search: '/search.html?keyword=',
  Episode: '/load-list-episode?ep_start=',
  Popular: '/popular.html?page=',
  Schedule: 'https://myanimelist.net/anime/season/schedule'
}

/**
 * Key name for local data
 */
export const LocalData = {
  FIRST_LAUNCH: '@FIRST',
  DATA_SAVER: '@dataSaver',
  HIDE_DUB: '@DUB', 
  TO_WATCH: '@Favourite', 
  WATCH_HISTORY: '@watch_history',
  LAST_EPISODE: '@last_episode',
  APP_VERSION: '@Version',
}