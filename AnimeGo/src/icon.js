// From dropfen 
// https://gist.github.com/dropfen/4a2209d7274788027f782e8655be198f

import FontAwesome from 'react-native-vector-icons/FontAwesome';
import Ionicons from 'react-native-vector-icons/Ionicons';
import Entypo from 'react-native-vector-icons/Entypo';
import MaterialIcons from 'react-native-vector-icons/MaterialIcons'
import { GREY } from 'react-native-material-color';

const replaceSuffixPattern = /--(active|big|small|very-big)/g;
const color = GREY[600];
const icons = {
  'home': [24, color, MaterialIcons],
  'new-releases': [24, color, MaterialIcons],
  'date-range': [24, color, MaterialIcons],
  'schedule': [24, color, MaterialIcons],
  'movie': [24, color, MaterialIcons],
  'whatshot': [24, color, MaterialIcons],
  'view-list': [24, color, MaterialIcons],
  'play-arrow': [24, color, MaterialIcons],
  'settings': [24, color, MaterialIcons],
}

const defaultIconProvider = Ionicons;

let iconsMap = {};
let iconsLoaded = new Promise((resolve, reject) => {
  new Promise.all(
    Object.keys(icons).map(iconName => {
      const Provider = icons[iconName][2] || defaultIconProvider; // Ionicons
      return Provider.getImageSource(
        iconName.replace(replaceSuffixPattern, ''),
        icons[iconName][0],
        icons[iconName][1]
      )
    })
  ).then(sources => {
    Object.keys(icons)
      .forEach((iconName, idx) => iconsMap[iconName] = sources[idx])
    // Call resolve (and we are done)
    resolve(true);
  })
});

export { iconsMap, iconsLoaded };