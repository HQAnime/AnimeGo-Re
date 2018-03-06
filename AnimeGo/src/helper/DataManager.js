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
        await AsyncStorage.setItem('@DUB', 'false');
        global.dataSaver = false;
      } else {
        // Retrieve DATA
        const dataSaver = await AsyncStorage.getItem('@dataSaver'); 
        const DUB = await AsyncStorage.getItem('@DUB'); 
        global.dataSaver = JSON.parse(dataSaver);
        global.hideDub = JSON.parse(DUB);
      }
    } catch (error) {
      console.error(error);
    }
  }
}

export {DataManager};