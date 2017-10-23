import React from 'react';
import { TabNavigator } from 'react-navigation';
import NewSeason from '../view/NewSeason';
import RecentRelease from '../view/RecentRelease';
import Genre from '../view/Genre';

export const Tabs = TabNavigator({
    RecentRelease: {
        screen: RecentRelease,
        title: 'Recent'
    },
    NewSeason: {
        screen: NewSeason,
        title: 'New Season'
    },
    Genre: {
        screen: Genre,
        title: 'Genre'
    }
});