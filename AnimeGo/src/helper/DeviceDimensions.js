import { Dimensions } from 'react-native';

const { width, height } = Dimensions.get('window');

// Check if device is portrait or horizontal
let isProtrait = (width < height) ? true : false;
export const deviceProtrait = isProtrait;

// Ignore rotation
export const deviceWidth = isProtrait ? width : height; 
export const deviceHeight = isProtrait ? height : width;
