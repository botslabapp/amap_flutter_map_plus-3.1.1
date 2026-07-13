import {
  Any,
  BinaryMessenger,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  StandardMethodCodec,
} from "@ohos/flutter_ohos";
import PlatformView, { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView'

import { common } from "@kit.AbilityKit";
import { AMapBuilder } from "./AMapComponent";
import { LogUtil } from "./utils/LogUtil";
import {
  AMap,
  AMapOptions,
  BitmapDescriptorFactory,
  CameraPosition,
  CameraUpdate,
  CameraUpdateFactory,
  CustomMapStyleOptions,
  LatLng,
  LatLngBounds,
  MapsInitializer,
  MapView,
  MapViewCreateCallback,
  MapViewManager,
  MyLocationStyle
} from "@amap/amap_lbs_map3d";
import { ConvertUtil } from "./utils/ConvertUtil";
import { Const } from "./utils/Const";
import { MarkersController } from "./overlays/marker/MarkersController";
import { CommonUtils } from "./utils/CommonUtils";
import { MyMethodCallHandler } from "./MyMethodCallHandler";
import { HashMap } from "@kit.ArkTS";
import { MapController } from "./core/MapController";
import { AMapOptionsBuilder } from "./AMapOptionsBuilder";
import { PolylinesController } from "./overlays/polyline/PolylinesController";
import { PolygonsController } from './overlays/polygon/PolygonsController';

/**
 * AMapPlatformView 封装地图平台视图，负责与Flutter MethodChannel通信及地图各类控制器的初始化与分发。
 * 主要功能：
 * 1. 初始化各类Controller（地图、Marker、Polyline、Polygon等）。
 * 2. 维护MethodChannel消息分发映射表，实现多类型消息处理。
 * 3. 提供地图操作接口（如moveCamera、dispose等）。
 * 4. 支持获取各类Controller实例，便于外部调用。
 */

@Observed
export class AMapPlatformView extends PlatformView implements MethodCallHandler {
  // Flutter通信通道
  public methodChannel: MethodChannel;
  // MethodCallHandler映射表，分发不同类型的消息
  myMethodCallHandlerMap?: HashMap<string, MyMethodCallHandler>;
  // 地图控制器
  mapController?: MapController;
  // Marker控制器
  markersController?: MarkersController;
  // Polyline控制器
  polylinesController?:PolylinesController
  // 地图参数构建器
  builder?:AMapOptionsBuilder
  // 上下文对象
  context?:common.UIAbilityContext
  // 视图ID
  private viewId: number;
  // Polygon控制器
  private polygonsController?: PolygonsController;

  /**
   * 构造函数，初始化MethodChannel及各类Controller
   * @param context 上下文
   * @param viewId 视图ID
   * @param options 地图参数
   * @param message Flutter消息通道
   * @param builder 地图参数构建器
   */
  constructor(context: common.UIAbilityContext, viewId: number, options: AMapOptions, message: BinaryMessenger, builder: AMapOptionsBuilder) {
    super();
    this.viewId = viewId;
    this.builder = builder;
    this.context = context;
    this.methodChannel = new MethodChannel(message, `amap_flutter_map_${viewId}`, StandardMethodCodec.INSTANCE);
    this.methodChannel.setMethodCallHandler(this);
    this.initMyMethodCallHandlerMap();
  }

  /**
   * 初始化MethodCallHandler映射表，将不同类型的消息分发到对应的Controller
   */
  initMyMethodCallHandlerMap() {
    this.markersController = new MarkersController(this.methodChannel, this.viewId);
    this.mapController = new MapController(this.methodChannel, this.context!, this.viewId);
    this.polylinesController = new PolylinesController(this.methodChannel, this.viewId);
    this.polygonsController = new PolygonsController(this.methodChannel, this.viewId);
    this.myMethodCallHandlerMap = new HashMap();

    // 注册地图相关方法
    let methodIdArray: string[] = this.mapController?.getRegisterMethodIdArray() ?? [];
    if (methodIdArray.length > 0) {
      for (let index = 0; index < methodIdArray.length; index++) {
        const methodId = methodIdArray[index];
        this.myMethodCallHandlerMap?.set(methodId, this.mapController);
      }
    }

    // 注册Marker相关方法
    methodIdArray = this.markersController?.getRegisterMethodIdArray() ?? [];
    if (methodIdArray.length > 0) {
      for (let index = 0; index < methodIdArray.length; index++) {
        const methodId = methodIdArray[index];
        this.myMethodCallHandlerMap?.set(methodId, this.markersController);
      }
    }

    // 注册Polyline相关方法
    methodIdArray = this.polylinesController?.getRegisterMethodIdArray();
    if (methodIdArray.length > 0) {
      for (let index = 0; index < methodIdArray.length; index++) {
        const methodId = methodIdArray[index];
        this.myMethodCallHandlerMap?.set(methodId, this.polylinesController);
      }
    }

    // 注册Polygon相关方法
    methodIdArray = this.polygonsController.getRegisterMethodIdArray();
    if (methodIdArray.length > 0) {
      for (let index = 0; index < methodIdArray.length; index++) {
        const methodId = methodIdArray[index];
        this.myMethodCallHandlerMap?.set(methodId, this.polygonsController);
      }
    }

    // 打印所有注册的消息处理器
    this.myMethodCallHandlerMap.forEach((value,key)=>{
      console.log('AMapPlatformView',`${key}:${value}`)
    })
  }

  /**
   * MethodChannel消息回调，分发到对应的Handler
   * @param call 方法调用对象
   * @param result 返回结果对象
   */
  onMethodCall(call: MethodCall, result: MethodResult): void {
    // 接受Dart侧发来的消息
    const methodId: string = call.method;
    console.debug('AMapPlatformView',"doMethodCall===>" + methodId)
    if (this.myMethodCallHandlerMap?.hasKey(methodId)) {
      this.myMethodCallHandlerMap?.get(methodId).doMethodCall(call, result);
    } else {
      result.notImplemented();
    }
  }

  // 定位样式对象
  private locationStyle: MyLocationStyle = new MyLocationStyle();

  /**
   * 移动相机到指定位置（示例方法）
   * @param cameraUpdate 相机更新对象
   * @param animatedObject 动画参数
   * @param durationObject 动画时长
   */
  async moveCamera(cameraUpdate: CameraUpdate, animatedObject: Object, durationObject: Object) {
    let aMap = Const.getAMap(this.viewId);
    let latitude = Const.getLatitude();
    let longitude = Const.getLongitude();
    aMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(latitude, longitude), 14));
  }

  /**
   * 获取地图组件视图
   * @returns WrappedBuilder
   */
  getView(): WrappedBuilder<[Params]> {
    return new WrappedBuilder(AMapBuilder);
  }

  /**
   * 获取当前视图ID
   * @returns 视图ID
   */
  public getViewId():number{
    return this.viewId
  }

  /**
   * 向Dart侧发送消息示例
   */
  public sendMessage = () => {
    console.log("nodeController sendMessage")
    //向Dart侧发送消息
    this.methodChannel.invokeMethod('getMessageFromOhosView', 'natvie - ');
  }

  /**
   * 释放资源，解绑事件
   */
  dispose(): void {
    this.builder?.offEventhub()
    this.mapController?.offEventhub()
  }

  /**
   * 获取地图控制器
   * @returns MapController
   */
  public getMapController(): MapController | undefined {
    LogUtil.i('AMapPlatformView',`viewId :${this.mapController?.viewId}`)
    return this.mapController;
  }

  /**
   * 获取Marker控制器
   * @returns MarkersController
   */
  public getMarkersController(): MarkersController | undefined {
    return this.markersController;
  }

  /**
   * 获取Polyline控制器
   * @returns PolylinesController
   */
  public getPolylinesController():PolylinesController | undefined{
    return this.polylinesController;
  }

  /**
   * 获取Polygon控制器
   * @returns PolygonsController
   */
  public getPolygonsController(): PolygonsController | undefined {
    return this.polygonsController;
  }
}