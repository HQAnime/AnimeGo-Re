import { AsyncStorage } from 'react-native';

class DataManager {
  static async setupData() {
    // Setup data here when app is launched
    try {
      const value = await AsyncStorage.getItem('@FIRST'); 
      if (value != 'false') {
        // First launch
        await AsyncStorage.setItem('@FIRST', 'false');
        await AsyncStorage.setItem('@dataSaver', 'false');
        global.dataSaver = false;
      } else {
        // Retrieve dataSaver
        const dataSaver = await AsyncStorage.getItem('@dataSaver'); 
        global.dataSaver = JSON.parse(dataSaver);
      }
    } catch (error) {
      console.error(error);
    }
  }
}

export {DataManager};