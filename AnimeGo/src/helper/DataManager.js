import { AsyncStorage } from 'react-native';
import { VERSION } from '../value';

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
        await AsyncStorage.setItem('@Favourite', JSON.stringify([]));
        await AsyncStorage.setItem('@Version', VERSION);
        global.dataSaver = false;
      } else {
        // Retrieve DATA
        const version = await AsyncStorage.getItem('@Version');
        if (version == null || version != VERSION) {
          // Adding more stuff here
          await DataManager.addMoreEntry();
          // Update version number
          AsyncStorage.setItem('@Version', VERSION);
        }
        const dataSaver = await AsyncStorage.getItem('@dataSaver'); 
        const DUB = await AsyncStorage.getItem('@DUB');
        const favList = await AsyncStorage.getItem('@Favourite');
        global.favList = JSON.parse(favList);
        console.log(global.favList);
        global.dataSaver = JSON.parse(dataSaver);
        global.hideDub = JSON.parse(DUB);
      }
    } catch (error) {
      console.error(error);
    }
  }

  static async addMoreEntry() {
    if (await AsyncStorage.getItem('@Favourite') == null)
      await AsyncStorage.setItem('@Favourite', JSON.stringify([]));
  }
}

export {DataManager};