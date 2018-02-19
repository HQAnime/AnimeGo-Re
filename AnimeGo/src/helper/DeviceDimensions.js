import { Dimensions } from 'react-native';

const { width, height } = Dimensions.get('window'); 
export const deviceWidth = (width < height) ? width : height; 
export const deviceHeight = (width > height) ? width : height;