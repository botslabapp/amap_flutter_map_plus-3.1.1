import { AMap } from '@amap/amap_lbs_map3d';
import { Any, MethodChannel } from '@ohos/flutter_ohos'
import { HashMap } from '@kit.ArkTS';

export abstract class AbstractOverlayController<T> {
  protected controllerMapByDartId: Map<string, T>;
  protected idMapByOverlyId: Map<string, string>;
  protected methodChannel: MethodChannel;

  constructor(methodChannel: MethodChannel) {
    this.methodChannel = methodChannel;
    this.controllerMapByDartId = new Map();
    this.idMapByOverlyId = new Map<string, string>();
  }
}