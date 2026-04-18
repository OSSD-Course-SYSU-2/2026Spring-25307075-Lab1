import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Context } from '@kit.AbilityKit';

export class CheckInManager {
  private static readonly KEY = 'checkCount';
  private static context: Context | null = null;

  // 初始化context（必须在调用其他方法前调用）
  static init(context: Context): void {
    CheckInManager.context = context;
  }

  // 保存打卡次数
  static async saveCheckIn(): Promise<number> {
    if (!CheckInManager.context) {
      throw new Error('CheckInManager not initialized!');
    }

    try {
      const options: preferences.Options = { name: 'checkInData' };
      const pref = preferences.getPreferencesSync(CheckInManager.context, options);
      const current = await pref.get(CheckInManager.KEY, 0);
      const newValue = Number(current) + 1;
      
      await pref.put(CheckInManager.KEY, newValue);
      await pref.flush();
      return newValue;
    } catch (err) {
      const e = err as BusinessError;
      console.error(`保存失败: ${e.code} - ${e.message}`);
      return 0;
    }
  }

  // 获取打卡总次数
  static async getCheckInCount(): Promise<number> {
    if (!CheckInManager.context) {
      throw new Error('CheckInManager not initialized!');
    }

    try {
      const options: preferences.Options = { name: 'checkInData' };
      const pref = preferences.getPreferencesSync(CheckInManager.context, options);
      const value = await pref.get(CheckInManager.KEY, 0);
      return Number(value);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`获取失败: ${e.code} - ${e.message}`);
      return 0;
    }
  }
}