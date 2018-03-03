import { Dimensions } from 'react-native';

// Check if device is portrait or horizontal
export function isPortrait() {
  const { width, height } = Dimensions.get('window');  
  return height >= width;
};

const { width, height } = Dimensions.get('window');
let portrait = (height >= width) ? true : false;
// Ignore rotation
export const deviceWidth = isPortrait ? width : height; 
export const deviceHeight = isPortrait ? height : width;
