import { Any, MethodCall, MethodChannel, MethodResult } from "@ohos/flutter_ohos";
import { Polygon } from "@amap/amap_lbs_map3d";
import { MyMethodCallHandler } from "../../MyMethodCallHandler";
import { LogUtil } from "../../utils/LogUtil";
import { Const } from "../../utils/Const";
import { PolygonController } from "./PolygonController";
import { PolygonUtil } from "./PolygonUtil";
import { AbstractOverlayController } from "../AbstractOverlayController";
import { CommonUtils } from "../../utils/CommonUtils";
import { PolygonOptionsBuilder } from "./PolygonOptionsBuilder";
import { ConvertUtil } from "../../utils/ConvertUtil";

export class PolygonsController
  extends AbstractOverlayController<PolygonController> implements MyMethodCallHandler {
  static CLASS_NAME = 'PolygonsController'
  private viewId: number;
  constructor(methodChannel: MethodChannel, viewId: number) {
    super(methodChannel)
    this.viewId = viewId;
  }

  getRegisterMethodIdArray(): string[] {
    return Const.METHOD_ID_LIST_FOR_POLYGON
  }

  doMethodCall(call: MethodCall, result: MethodResult): void {
    const methodId: string = call.method;
    const args: Any = call.args;
    LogUtil.i('PolygonsController', `doMethodCall methodId:${methodId}`);

    switch (methodId) {
      case Const.METHOD_POLYGON_UPDATE:
        this.invokePolygonOptions(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }
  invokePolygonOptions(methodCall:MethodCall,result:MethodResult){
    if (!methodCall) {
      return
    }
    let args: Any = methodCall.args;

    let polygonsToAdd: object = CommonUtils.argumentParse('polygonsToAdd', args)
    this.addByList(polygonsToAdd as object[])

    let polygonsToChange: object = CommonUtils.argumentParse('polygonsToChange', args)
    this.updateByList(polygonsToChange as object[]);

    let polygonsToRemove: object = CommonUtils.argumentParse('polygonIdsToRemove', args)
    this.removeByIdList(polygonsToRemove as object[]);

    result.success(null)
  }

  private addPolygon(args: object): void {
    let builder = new PolygonOptionsBuilder()
    const dartId = PolygonUtil.interpretOptions(args, builder);
    const aMap = Const.getAMap(this.viewId);
    if (aMap) {
      let options = builder.build()
      const polygon = aMap.addPolygon(options);
      if (polygon) {
        const controller = new PolygonController(polygon);
        this.controllerMapByDartId.set(dartId, controller);
        this.idMapByOverlyId.set(polygon.getId(), dartId)
      }
    }
  }
  updateByList(polygonsToChange:object[]){
    if (polygonsToChange) {
      for (let index = 0; index < polygonsToChange.length; index++) {
        const element = polygonsToChange[index];
        this.update(element)
      }
    }
  }
  removeByIdList(polygonsToRemove:Object[]){
    if (polygonsToRemove == undefined) {
      return;
    }

    for (let index = 0; index < polygonsToRemove.length; index++) {
      const rawPolygonId = polygonsToRemove[index];
      if (rawPolygonId == undefined) {
        continue;
      }
      let polygonId: string = rawPolygonId as string;
      const polygonController: PolygonController | undefined = this.controllerMapByDartId.get(polygonId);
      this.controllerMapByDartId.delete(polygonId);
      if (polygonController != undefined && polygonController.getId() != undefined) {
        this.idMapByOverlyId.delete(polygonController.getId());
        polygonController.remove();
      }
    }
  }

  update(obj:object){
    let dartId:string|undefined = CommonUtils.argumentParse('id',obj)
    if (dartId) {
      let controller = this.controllerMapByDartId.get(dartId)
      if (controller) {
        PolygonUtil.interpretOptions(obj,controller)
      }
    }
  }


  public addByList(polygonList: Object[]): void {
    if (polygonList){
      polygonList.forEach((polygonData) => {
        const args:Map<string, Any> = polygonData as Map<string, Any>;
        this.addPolygon(args);
      });
    }

  }
} 