
import { FlutterAbility, FlutterEngine } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

const PERMISSIONS: Array<Permissions> = [
  'ohos.permission.INTERNET',
  'ohos.permission.APPROXIMATELY_LOCATION',
  'ohos.permission.LOCATION'
];

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    super.onWindowStageCreate(windowStage);
    this.requestPermissions();
  }

  /**
   * 向用户申请网络和位置权限
   */
  private requestPermissions(): void {
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    const context = this.context as common.UIAbilityContext;
    atManager.requestPermissionsFromUser(context, PERMISSIONS)
      .then((data) => {
        const grantStatus: Array<number> = data.authResults;
        for (let i = 0; i < grantStatus.length; i++) {
          if (grantStatus[i] === 0) {
            console.info(`Permission ${PERMISSIONS[i]} granted.`);
          } else {
            console.warn(`Permission ${PERMISSIONS[i]} denied.`);
          }
        }
      })
      .catch((err: BusinessError) => {
        console.error(`requestPermissionsFromUser failed, code: ${err.code}, message: ${err.message}`);
      });
  }
}
