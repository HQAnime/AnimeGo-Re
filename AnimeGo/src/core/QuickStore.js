import { AsyncStorage } from 'react-native';

export default class QuickStore {
  /**
   * Save a data to async storage
   * @param key key to save to
   * @param data stringify then save to key
   */
  static async save(key, data) {
    AsyncStorage.setItem(key, JSON.stringify(data));
  }

  /**
   * Get data from async storage with a default value
   * @param key  key to get from
   * @param default_value deafult value in case of null
   */
  static async get(key, default_value) {
    var value = JSON.parse(await AsyncStorage.getItem(key));
    // Set it to default if no value
    if (value == null) value = default_value;
    return value;
  }
}