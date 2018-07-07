import { VERSION, LocalData } from '../value';
import QuickStore from './QuickStore';

class DataManager {
  static async setupData() {
    // Get data from storage
    global.hide_dub = await QuickStore.get(LocalData.HIDE_DUB, true);
    global.watch_list = await QuickStore.get(LocalData.TO_WATCH, []);
    // It will be a direct link to your last episode
    global.last_episode = await QuickStore.get(LocalData.LAST_EPISODE, '');
  }
}

export {DataManager};