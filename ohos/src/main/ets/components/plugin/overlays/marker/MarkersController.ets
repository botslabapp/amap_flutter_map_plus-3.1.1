// MarkersController.ets
import { AMap, Marker, MarkerOptions } from "@amap/amap_lbs_map3d";
import { Any, MethodCall, MethodChannel, MethodResult } from "@ohos/flutter_ohos";
import { CommonUtils } from "../../utils/CommonUtils";
import { ConvertUtil } from "../../utils/ConvertUtil";
import { MarkerController } from "./MarkerController";
import { MarkerOptionsBuilder } from "./MarkerOptionsBuilder";
import { MarkerUtil } from "./MarkerUtil";
import { AbstractOverlayController } from "../AbstractOverlayController"
import { MyMethodCallHandler } from "../../MyMethodCallHandler";
import { Const } from "../../utils/Const";
import { ArrayList } from "@kit.ArkTS";

export class MarkersController
  extends AbstractOverlayController<MarkerController> implements MyMethodCallHandler{

  private viewId: number;
  constructor(methodChannel: MethodChannel, viewId: number) {
    super(methodChannel);
    this.viewId = viewId;
  }

  doMethodCall(call: MethodCall, result: MethodResult): void {
    const method: string = call.method;
    switch (method) {
      case Const.METHOD_MARKER_UPDATE:
        this.invokeMarkerOptions(call, result);
        break;
    }
  }

  getRegisterMethodIdArray(): string[] {
    return Const.METHOD_ID_LIST_FOR_MARKER;
  }

  public invokeMarkerOptions(methodCall: MethodCall, result: MethodResult): void {

    let args: Any = methodCall.args;

    let markersToAdd: object = CommonUtils.argumentParse('markersToAdd', args)
    this.addByList(markersToAdd as object[])

    let markersToChange: object = CommonUtils.argumentParse('markersToChange', args)
    this.updateByList(markersToChange as object[]);

    let markerIdsToRemove: object = CommonUtils.argumentParse('markersToRemove', args)
    this.removeByIdList(markerIdsToRemove as object[]);

    result.success(null)
  }

  public addByList(markersToAdd: object[] ) {
    markersToAdd.forEach((value) => {
      this.add(value)
    })
  }

  private async add(markerObj: object) {
    let builder: MarkerOptionsBuilder = new MarkerOptionsBuilder();
    let dartMarkerId: string | undefined = await MarkerUtil.interpretMarkerOptions(markerObj, builder);
    if (dartMarkerId != undefined) {
      let markerOptions: MarkerOptions = builder.build();
      let aMap = Const.getAMap(this.viewId);
      const marker = aMap?.addMarker(markerOptions)
      let clickable: Object = CommonUtils.argumentParse('clickable', markerObj)
      if (clickable != undefined) {
        marker?.setClickable(ConvertUtil.toBoolean(clickable));
      }
      let markerController = new MarkerController(marker);
      this.controllerMapByDartId.set(dartMarkerId, markerController)
    }
  }

  private updateByList(markersToChange: Object[]) {
    if (markersToChange != undefined) {
      for (let index = 0; index < markersToChange.length; index++) {
        const element = markersToChange[index];
        this.update(element)
      }
    }
  }

  private update(markerToChange: Object) {
    let dartMarkerId: string = CommonUtils.argumentParse('id', markerToChange)
    if (dartMarkerId && this.controllerMapByDartId.has(dartMarkerId)) {
      let markerController = this.controllerMapByDartId.get(dartMarkerId)
      if (markerController) {
        MarkerUtil.interpretMarkerOptions(markerToChange, markerController)
      }
    }
  }

  private removeByIdList(markerIdsToRemove: Object[]) {
    if (markerIdsToRemove == undefined) {
      return;
    }

    for (let index = 0; index < markerIdsToRemove.length; index++) {
      const rawMarkerId = markerIdsToRemove[index];
      if (rawMarkerId == undefined) {
        continue;
      }
      let markerId: string = rawMarkerId as string;
      const markerController: MarkerController | undefined = this.controllerMapByDartId.get(markerId);
      this.controllerMapByDartId.delete(markerId);
      if (markerController != undefined && markerController.getMarkerId() != undefined) {
        this.idMapByOverlyId.delete(markerController.getMarkerId()!);
        markerController.remove();
      }
    }
  }
}