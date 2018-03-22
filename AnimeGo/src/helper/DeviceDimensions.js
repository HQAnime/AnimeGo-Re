import { Dimensions, Alert } from 'react-native';

// Check if device is portrait or horizontal
export function isPortrait() {
  const { width, height } = Dimensions.get('window');  
  return height >= width;
};

// Ignore rotation
const { width, height } = Dimensions.get('window');  
export const deviceWidth = isPortrait() ? width : height; 
export const deviceHeight = isPortrait() ? height : width;
