import { LatLng, Polyline, PolylineOptions } from "@amap/amap_lbs_map3d";
import { Any, MethodCall, MethodChannel, MethodResult } from "@ohos/flutter_ohos";
import { MyMethodCallHandler } from "../../MyMethodCallHandler";
import { CommonUtils } from "../../utils/CommonUtils";
import { Const } from "../../utils/Const";
import { AbstractOverlayController } from "../AbstractOverlayController";
import { PolylineController } from "./PolylineController";
import { PolylineOptionsBuilder } from "./PolylineOptionsBuilder";
import { PolylineUtil } from "./PolylineUtil";
import { ArrayList } from "@kit.ArkTS";
import { LogUtil } from "../../utils/LogUtil";

export class PolylinesController extends AbstractOverlayController<PolylineController> implements MyMethodCallHandler{
  private static CLASS_NAME = 'PolylinesController'
  private viewId: number;

  constructor(methodChannel: MethodChannel, viewId: number) {
    super(methodChannel)
    this.viewId = viewId;
  }


  getRegisterMethodIdArray(): string[] {
    return Const.METHOD_ID_LIST_FOR_POLYLINE
  }

  doMethodCall(call: MethodCall, result: MethodResult): void {
    console.log(PolylinesController.CLASS_NAME, "doMethodCall===>" + call.method);
    const methodStr = call.method
    switch (methodStr){
      case Const.METHOD_POLYLINE_UPDATE:
        this.invokePolylineOptions(call,result);
        break
    }
  }
  invokePolylineOptions(methodCall:MethodCall,result:MethodResult){
    let args: Any = methodCall.args;

    let polylinesToAdd: object = CommonUtils.argumentParse('polylinesToAdd', args)
    this.addByList(polylinesToAdd as object[])

    let polylinesToChange: object = CommonUtils.argumentParse('polylinesToChange', args)
    this.updateByList(polylinesToChange as object[]);

    let polylineIdsToRemove: object = CommonUtils.argumentParse('polylineIdsToRemove', args)
    this.removeByIdList(polylineIdsToRemove as object[]);

    result.success(null)
  }

  public addByList(polylinesToAdd: object[]) {
    polylinesToAdd.forEach((value) => {
      this.add(value)
    })
  }

  private async add(polylineObj: object) {
    let builder: PolylineOptionsBuilder = new PolylineOptionsBuilder();
    let dartPolylineId: string | undefined = await PolylineUtil.interpretOptions(polylineObj, builder);
    if (dartPolylineId != undefined) {
      console.log('PolylinesController',`需要添加的id是:${dartPolylineId}`)
      let polylineOptions: PolylineOptions = builder.build();
      let aMap = Const.getAMap(this.viewId);
      const polyline = aMap?.addPolyline(polylineOptions)
      if (polyline) {
        console.log('PolylinesController',`添加成功:${polyline.getWidth()}:${polyline.getColor()},${polyline.getPoints()}`)
        let polylineController = new PolylineController(polyline);
        this.controllerMapByDartId.set(dartPolylineId, polylineController)
      }

    }
  }

  private updateByList(polylinesToChange: Object[]) {
    if (polylinesToChange != undefined) {
      for (let index = 0; index < polylinesToChange.length; index++) {
        const element = polylinesToChange[index];
        this.update(element)
      }
    }
  }

  private update(polylineToChange: Object) {
    let dartPolylineId: string = CommonUtils.argumentParse('id', polylineToChange)
    if (dartPolylineId && this.controllerMapByDartId.has(dartPolylineId)) {
      let polylineController = this.controllerMapByDartId.get(dartPolylineId)
      if (polylineController) {
        PolylineUtil.interpretOptions(polylineToChange, polylineController)
      }
    }
  }

  private removeByIdList(polylineIdsToRemove: Object[]) {
    if (polylineIdsToRemove == undefined) {
      return;
    }

    for (let index = 0; index < polylineIdsToRemove.length; index++) {
      const dartPolylineId = polylineIdsToRemove[index];
      if (dartPolylineId == undefined) {
        continue;
      }
      let polylineId: string = dartPolylineId as string;
      const polylineController: PolylineController | undefined = this.controllerMapByDartId.get(polylineId);
      this.controllerMapByDartId.delete(polylineId);
      if (polylineController != undefined && polylineController.getPolylineId() != undefined) {
        this.idMapByOverlyId.delete(polylineController.getPolylineId()!);
        polylineController.remove();
      }
    }
  }
}