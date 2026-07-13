import {
  CameraPosition,
  CustomMapStyleOptions,
  MyLocationStyle,
  LatLngBounds,
  AMap,
  MapView,
  Poi,
  CameraUpdate,
  CameraUpdateFactory,
  LatLng,
  CancelableCallback,
  OnCameraChangeListener
} from "@amap/amap_lbs_map3d";
import { Any, MethodCall, MethodChannel, MethodResult } from "@ohos/flutter_ohos";
import { MyMethodCallHandler } from "../MyMethodCallHandler";
import { CommonUtils } from "../utils/CommonUtils";
import { Const } from "../utils/Const";
import { ConvertUtil } from "../utils/ConvertUtil";
import { AMapOptionsSink } from "./AMapOptionsSink";
import { ArrayList } from "@kit.ArkTS";
import { common } from "@kit.AbilityKit";
import { geoLocationManager } from "@kit.LocationKit";
import { LogUtil } from "../utils/LogUtil";
/**
 * MapController 地图控制器，实现MyMethodCallHandler和AMapOptionsSink接口。
 * 主要功能：
 * 1. 处理地图相关MethodChannel消息，实现Flutter与原生地图的通信。
 * 2. 提供地图参数设置、地图事件监听、地图操作等接口。
 * 3. 负责地图初始化完成后的事件绑定与解绑。
 */

export class MapController implements MyMethodCallHandler, AMapOptionsSink {
  // Flutter MethodChannel对象
  methodChannel?: MethodChannel;
  // 上下文对象
  context?:common.UIAbilityContext
  // 视图ID
  public viewId: number;

  /**
   * 构造函数，初始化并绑定地图初始化完成事件
   * @param methodChannel Flutter通信通道
   * @param context 上下文
   * @param viewId 视图ID
   */
  constructor(methodChannel: MethodChannel, context: common.UIAbilityContext, viewId: number) {
    this.methodChannel = methodChannel;
    this.context = context;
    this.viewId = viewId;
    // 监听地图初始化完成事件
    this.context.eventHub.on(`onMapFinished_${this.viewId}`, this.afterInit.bind(this))
  }

  /**
   * 解绑地图初始化完成事件
   */
  public offEventhub(){
    this.context?.eventHub.off(`onMapFinished_${this.viewId}`)
  }

  /**
   * 地图初始化完成后的回调，绑定地图事件监听
   */
  private afterInit(){
    const amap = Const.getAMap(this.viewId)
    if (amap) {
      // 监听定位变化
      amap.setOnMyLocationChangeListener((location: geoLocationManager.Location)=>{
        if (this.methodChannel && this.myLocationShowing) {
          let params:Map<string,Any> = new Map()
          params.set('location',ConvertUtil.location2Map(location))
          this.methodChannel.invokeMethod('location#changed',params)
        }
      })
      // 监听相机移动
      amap.setOnCameraChangeListener(new OnCameraChangeListener(
        (position: CameraPosition) => {
          if (this.methodChannel) {
            let params:Map<string,Any> = new Map()
            params.set('position',ConvertUtil.cameraPositionToMap(position))
            this.methodChannel.invokeMethod('camera#onMove',params)
          }
        },
        (position: CameraPosition) => {
          if (this.methodChannel) {
            let params:Map<string,Any> = new Map()
            params.set('position',ConvertUtil.cameraPositionToMap(position))
            this.methodChannel.invokeMethod('camera#onMoveEnd',params)
          }
        }));
      // 监听地图单击
      amap.setOnMapClickListener((point: LatLng) => {
        if (this.methodChannel) {
          let params:Map<string,Any> = new Map()
          params.set('latLng',[point.latitude,point.longitude])
          this.methodChannel.invokeMethod('map#onTap',params)
        }
      });
      // 监听地图长按
      amap.setOnMapLongClickListener((point: LatLng) => {
        if (this.methodChannel) {
          let params:Map<string,Any> = new Map()
          params.set('latLng',[point.latitude,point.longitude])
          this.methodChannel.invokeMethod('map#onLongPress',params)
        }
      });
      // 监听POI点击
      amap.addOnPOIClickListener((poi: Poi) => {
        if (this.methodChannel) {
          let params:Map<string,Any> = new Map()
          params.set('poi',ConvertUtil.poiToMap(poi))
          this.methodChannel.invokeMethod('map#onPoiTouched',params)
        }
      });
    }
  }

  /**
   * 获取本控制器注册的方法ID列表
   * @returns 方法ID数组
   */
  getRegisterMethodIdArray(): string[] {
    return Const.METHOD_ID_LIST_FOR_MAP;
  }

  /**
   * MethodChannel消息分发处理
   * @param call 方法调用对象
   * @param result 返回结果对象
   */
  doMethodCall(call: MethodCall, result: MethodResult): void {
    const aMap = Const.getAMap(this.viewId)
    const method: string = call.method;

    switch (method) {
      case 'getMessageFromFlutterView':
        let value: ESObject = call.args;
        console.log("nodeController receive message from dart: ");
        result.success(true);
        break;

      case Const.METHOD_MAP_WAIT_FOR_MAP:
        let mapLoaded = Const.getMapLoaded(this.viewId);
        console.error("waitForMap mapLoaded:" + mapLoaded)
        if (mapLoaded) {
          console.error("waitForMap callback 1")
          result.success(null)
          return
        }
        console.error("waitForMap set mapReadyResult")
        Const.setMapReadyResult(result, this.viewId);
        break;

      case Const.METHOD_MAP_SATELLITE_IMAGE_APPROVAL_NUMBER:
        result.success(aMap?.getSatelliteImageApprovalNumber())
        break;

      case Const.METHOD_MAP_CONTENT_APPROVAL_NUMBER:
        result.success(aMap?.getMapContentApprovalNumber())
        break;

      case Const.METHOD_MAP_UPDATE:
        ConvertUtil.interpretAMapOptions(CommonUtils.argumentParse('options', call.args), this)
        break;

      case Const.METHOD_MAP_MOVE_CAMERA:
        let cameraUpdate: CameraUpdate =
          ConvertUtil.toCameraUpdate(CommonUtils.argumentParse("cameraUpdate", call.args))
        let animatedObject: Object = CommonUtils.argumentParse("animated", call.args);
        let durationObject: Object = CommonUtils.argumentParse("duration", call.args);
        this.moveCamera(cameraUpdate);
        break;

      case Const.METHOD_MAP_SET_RENDER_FPS:
        if (aMap != undefined) {
          aMap.setRenderFps(CommonUtils.argumentParse("fps", call.args))
          result.success(null);
        }
        break;

      case Const.METHOD_MAP_TAKE_SNAPSHOT:
        if (aMap != undefined) {
          const _result: MethodResult = result;
          //todo
          _result.success(null)
        }
        break;

      case Const.METHOD_MAP_CLEAR_DISK:
        if (aMap != undefined) {
          // aMap.removecache();
          result.success(null);
        }
        break;

      case Const.METHOD_MAP_GET_SCALE_PER_PIXEL:
        // 获取地图当前比例尺：1像素点对应的距离长度（米）
        // 高德 ohos SDK 暂未提供该接口时返回 null，保证 Dart 端不报未实现
        try {
          result.success(aMap?.getScalePerPixel());
        } catch (e) {
          result.success(null);
        }
        break;
      default:
        console.info("onMethodCall not find methodId:" + call.method);
        break;
    }
  }

  /**
   * 设置相机位置
   * @param camera CameraPosition
   */
  setCamera(camera: CameraPosition): void {
    LogUtil.i('MapController',`${camera.target.toString()}`)
    let aMap = Const.getAMap(this.viewId);
    aMap?.moveCamera(CameraUpdateFactory.newCameraPosition(camera));
  }

  /**
   * 设置地图类型
   * @param mapType 地图类型
   */
  setMapType(mapType: number): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.setMapType(mapType);
  }

  /**
   * 设置自定义地图样式（暂未实现）
   * @param options CustomMapStyleOptions
   */
  setCustomMapStyleOptions(options: CustomMapStyleOptions): void {
    throw new Error("Method not implemented.");
  }

  // 是否显示定位
  myLocationShowing = false

  /**
   * 设置定位样式
   * @param style MyLocationStyle
   */
  setMyLocationStyle(style: MyLocationStyle): void {
    const aMap = Const.getAMap(this.viewId)
    this.myLocationShowing = style.isMyLocationShowing()
    aMap?.setMyLocationEnabled(this.myLocationShowing)
    aMap?.setMyLocationStyle(style)
  }

  /**
   * 设置定位锚点（预留）
   * @param x 锚点X
   * @param y 锚点Y
   */
  setScreenAnchor(x: number, y: number): void {

  }

  /**
   * 设置最小缩放级别
   * @param minZoomLevel 最小缩放级别
   */
  setMinZoomLevel(minZoomLevel: number): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.setMinZoomLevel(minZoomLevel);
  }

  /**
   * 设置最大缩放级别
   * @param maxZoomLevel 最大缩放级别
   */
  setMaxZoomLevel(maxZoomLevel: number): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.setMaxZoomLevel(maxZoomLevel);
  }

  /**
   * 设置地图显示范围
   * @param bounds LatLngBounds
   */
  setLatLngBounds(bounds: LatLngBounds): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.setMapStatusLimits(bounds);
  }

  /**
   * 设置路况显示
   * @param enabled 是否显示
   */
  setTrafficEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.setTrafficEnabled(enabled);
  }

  /**
   * 设置POI点击
   * @param enabled 是否支持
   */
  setTouchPoiEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.setTouchPoiEnable(enabled);
  }

  /**
   * 设置建筑物显示
   * @param enabled 是否显示
   */
  setBuildingsEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.showBuildings(enabled);
  }

  /**
   * 设置标签显示
   * @param enabled 是否显示
   */
  setLabelsEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.showMapText(enabled);
  }

  /**
   * 设置指南针显示
   * @param enabled 是否显示
   */
  setCompassEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.getUiSettings()?.setCompassEnabled(enabled);
  }

  /**
   * 设置比例尺显示
   * @param enabled 是否显示
   */
  setScaleEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.getUiSettings()?.setScaleControlsEnabled(enabled);
  }

  /**
   * 设置缩放手势
   * @param enabled 是否支持
   */
  setZoomGesturesEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.getUiSettings()?.setZoomGesturesEnabled(enabled);
  }

  /**
   * 设置拖动手势
   * @param enabled 是否支持
   */
  setScrollGesturesEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.getUiSettings()?.setScrollGesturesEnabled(enabled);
  }

  /**
   * 设置旋转手势
   * @param enabled 是否支持
   */
  setRotateGesturesEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.getUiSettings()?.setRotateGesturesEnabled(enabled);
  }

  /**
   * 设置倾斜手势
   * @param enabled 是否支持
   */
  setTiltGesturesEnabled(enabled: boolean): void {
    const aMap = Const.getAMap(this.viewId)
    aMap?.getUiSettings()?.setTiltGesturesEnabled(enabled);
  }

  /**
   * 设置初始marker（预留）
   * @param markers marker数组
   */
  setInitialMarkers(markers: object[]): void {
    //不实现，其他地方会处理markers
  }

  /**
   * 设置初始polyline（预留）
   * @param polylines polyline数组
   */
  setInitialPolylines(polylines: object[]): void {
    //不实现，其他地方会处理polylines
  }

  /**
   * 设置初始polygon（预留）
   * @param polygons polygon数组
   */
  setInitialPolygons(polygons: object[]): void {
    //不实现，其他地方会处理polygons
  }

  /**
   * 移动相机到指定位置
   * @param cameraUpdate CameraUpdate对象
   */
  async moveCamera(cameraUpdate: CameraUpdate) {
    let aMap = Const.getAMap(this.viewId)
    aMap?.moveCamera(cameraUpdate);
  }
}
