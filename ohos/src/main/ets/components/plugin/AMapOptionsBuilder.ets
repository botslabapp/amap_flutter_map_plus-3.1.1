import {
  CameraPosition,
  CustomMapStyleOptions,
  MyLocationStyle,
  LatLngBounds,
  AMapOptions,
  LatLngBoundsBuilder,
  CameraUpdateFactory,
  AMap
} from "@amap/amap_lbs_map3d";
import { AMapPlatformView } from "./AMapPlatformView";
import { AMapOptionsSink } from "./core/AMapOptionsSink";
import { common, Context } from "@kit.AbilityKit";
import { Any, BinaryMessenger } from "@ohos/flutter_ohos";
import { ConvertUtil } from "./utils/ConvertUtil";
import { ArrayList } from "@kit.ArkTS";
import { Const } from "./utils/Const";
import { LogUtil } from "./utils/LogUtil";

/**
 * 地图参数构建器，实现AMapOptionsSink接口
 * 用于配置地图初始化参数和相关属性
 */
export class AMapOptionsBuilder implements AMapOptionsSink {
  // 地图配置选项
  options: AMapOptions = new AMapOptions();
  // 自定义地图样式
  customMapStyleOptions?: CustomMapStyleOptions;
  // 定位样式
  myLocationStyle?: MyLocationStyle;
  // 最小缩放级别
  minZoomLevel: number = 3;
  // 最大缩放级别
  maxZoomLevel: number = 20;
  // 地图显示范围
  latLngBounds?: LatLngBounds;
  // 是否显示路况
  trafficEnabled: boolean = true;
  // 是否支持点击POI
  touchPoiEnabled: boolean = true;
  // 是否显示建筑物
  buildingsEnabled: boolean = true;
  // 是否显示标签
  labelsEnabled: boolean = true;
  // 定位蓝点锚点X
  anchorX: number = 2.0
  // 定位蓝点锚点Y
  anchorY: number = 2.0
  // 初始marker数据
  initialMarkers?: Object;
  // 初始polyline数据
  initialPolylines?: Object;
  // 初始polygon数据
  initialPolygons?: Object;
  // 地图平台视图对象
  private aMapPlatformView?: AMapPlatformView
  // 上下文对象
  private context?: Context
  // 视图ID
  private viewId?: number

  /**
   * 构建地图平台视图
   * @param id 视图ID
   * @param context 上下文
   * @param binaryMessenger 消息通道
   * @returns AMapPlatformView
   */
  build(id: number, context: Context, binaryMessenger: BinaryMessenger): AMapPlatformView {
    this.viewId = id;
    // 默认关闭缩放控件
    this.options.zoomControlsEnabled(false)
    let platformView = new AMapPlatformView(context as common.UIAbilityContext, id, this.options, binaryMessenger, this);
    this.aMapPlatformView = platformView 
    this.context = context
    // 监听地图初始化完成事件
    this.context.eventHub.on(`onMapFinished_${id}`, this.afterInit.bind(this))
    return this.aMapPlatformView!;
  }

  /**
   * 解绑事件监听
   */
  public offEventhub() {
    if (this.viewId !== undefined) {
      this.context?.eventHub.off(`onMapFinished_${this.viewId}`)
    }
  }

  /**
   * 地图初始化完成后的回调
   */
  private  afterInit(){
    console.log('AMapOptionsBuilder',`initFinished ${this.viewId},${this.aMapPlatformView?.getViewId()}`)
    console.log('AMapOptionsBuilder',`markers:${this.initialMarkers}`)
    // 设置初始相机位置
    if (this.options.getCamera() != undefined){
      this.aMapPlatformView?.getMapController()?.setCamera(this.options.getCamera()!)
    }
    // 设置自定义地图样式
    if (this.customMapStyleOptions != undefined) {
      this.aMapPlatformView?.getMapController()?.setCustomMapStyleOptions(this.customMapStyleOptions);
    }
    // 设置定位样式
    if (this.myLocationStyle != undefined) {
      this.aMapPlatformView?.getMapController()?.setMyLocationStyle(this.myLocationStyle);
    }
    // 设置定位锚点
    if (this.anchorX >= 0
      && this.anchorX <= 1.0
      && this.anchorY <= 1.0
      && this.anchorY >= 0) {
      this.aMapPlatformView?.getMapController()?.setScreenAnchor(this.anchorX, this.anchorY);
    }
    // 设置缩放级别范围
    this.aMapPlatformView?.getMapController()?.setMinZoomLevel(this.minZoomLevel);
    this.aMapPlatformView?.getMapController()?.setMaxZoomLevel(this.maxZoomLevel);
    // 设置地图显示范围
    if (undefined != this.latLngBounds) {
      this.aMapPlatformView?.getMapController()?.setLatLngBounds(this.latLngBounds);
    }
    // 设置路况、POI、建筑物、标签等显示
    this.aMapPlatformView?.getMapController()?.setTrafficEnabled(this.trafficEnabled);
    this.aMapPlatformView?.getMapController()?.setTouchPoiEnabled(this.touchPoiEnabled);
    this.aMapPlatformView?.getMapController()?.setBuildingsEnabled(this.buildingsEnabled);
    this.aMapPlatformView?.getMapController()?.setLabelsEnabled(this.labelsEnabled);
    // 添加初始marker
    if (undefined != this.initialMarkers) {
      let markerList:Object[]  = ConvertUtil.toList(this.initialMarkers);
      LogUtil.i('AMapOptionsBuilder',`markerList : ${markerList.length}`)
      this.aMapPlatformView?.getMarkersController()?.addByList(markerList);
    }
    // 添加初始polyline
    if (undefined != this.initialPolylines) {
      let polylineList: Object[]  = ConvertUtil.toList(this.initialPolylines);
      LogUtil.i('AMapOptionsBuilder',`polylineList : ${polylineList.length}`)
      if (polylineList.length > 0) {
        this.aMapPlatformView?.getPolylinesController()?.addByList(polylineList)
      }
    }
    // 添加初始polygon
    if (undefined != this.initialPolygons) {
      let polygonList = ConvertUtil.toList(this.initialPolygons);
      LogUtil.i('AMapOptionsBuilder', `initialPolygons length:${polygonList.length}`);
      if (polygonList.length > 0) {
        this.aMapPlatformView?.getPolygonsController()?.addByList(polygonList);
      }
    }
  }

  /**
   * 设置相机位置
   * @param camera CameraPosition
   */
  setCamera(camera: CameraPosition): void {
    this.options.camera(camera);
  }

  /**
   * 设置地图类型
   * @param mapType 地图类型
   */
  setMapType(mapType: number): void {
    this.options.mapType(mapType);
  }

  /**
   * 设置自定义地图样式
   * @param options CustomMapStyleOptions
   */
  setCustomMapStyleOptions(options: CustomMapStyleOptions): void {
    this.customMapStyleOptions = options;
  }

  /**
   * 设置定位样式
   * @param style MyLocationStyle
   */
  setMyLocationStyle(style: MyLocationStyle): void {
    this.myLocationStyle = style;
  }

  /**
   * 设置定位锚点
   * @param x 锚点X
   * @param y 锚点Y
   */
  setScreenAnchor(x: number, y: number): void {
    this.anchorX = x;
    this.anchorY = y;
  }

  /**
   * 设置最小缩放级别
   * @param minZoomLevel 最小缩放级别
   */
  setMinZoomLevel(minZoomLevel: number): void {
    this.minZoomLevel = minZoomLevel;
  }

  /**
   * 设置最大缩放级别
   * @param maxZoomLevel 最大缩放级别
   */
  setMaxZoomLevel(maxZoomLevel: number): void {
    this.maxZoomLevel = maxZoomLevel;
  }

  /**
   * 设置地图显示范围
   * @param bounds LatLngBounds
   */
  setLatLngBounds(bounds: LatLngBounds): void {
    this.latLngBounds = bounds;
  }

  /**
   * 设置路况显示
   * @param enabled 是否显示
   */
  setTrafficEnabled(enabled: boolean): void {
    this.trafficEnabled = enabled;
  }

  /**
   * 设置POI点击
   * @param enabled 是否支持
   */
  setTouchPoiEnabled(enabled: boolean): void {
    this.touchPoiEnabled = enabled;
  }

  /**
   * 设置建筑物显示
   * @param enabled 是否显示
   */
  setBuildingsEnabled(enabled: boolean): void {
    this.buildingsEnabled = enabled;
  }

  /**
   * 设置标签显示
   * @param enabled 是否显示
   */
  setLabelsEnabled(enabled: boolean): void {
    this.labelsEnabled = enabled;
  }

  /**
   * 设置指南针显示
   * @param enabled 是否显示
   */
  setCompassEnabled(enabled: boolean): void {
    this.options.compassEnabled(enabled);
  }

  /**
   * 设置比例尺显示
   * @param enabled 是否显示
   */
  setScaleEnabled(enabled: boolean): void {
    this.options.scaleControlsEnabled(enabled);
  }

  /**
   * 设置缩放手势
   * @param enabled 是否支持
   */
  setZoomGesturesEnabled(enabled: boolean): void {
    this.options.zoomGesturesEnabled(enabled);
  }

  /**
   * 设置拖动手势
   * @param enabled 是否支持
   */
  setScrollGesturesEnabled(enabled: boolean): void {
    this.options.scrollGesturesEnabled(enabled);
  }

  /**
   * 设置旋转手势
   * @param enabled 是否支持
   */
  setRotateGesturesEnabled(enabled: boolean): void {
    this.options.rotateGesturesEnabled(enabled);
  }

  /**
   * 设置倾斜手势
   * @param enabled 是否支持
   */
  setTiltGesturesEnabled(enabled: boolean): void {
    this.options.tiltGesturesEnabled(enabled);
  }

  /**
   * 设置初始marker数据
   * @param markers marker数组
   */
  setInitialMarkers(markers: object[]): void {
    this.initialMarkers = markers;
  }

  /**
   * 设置初始polyline数据
   * @param polylines polyline数组
   */
  setInitialPolylines(polylines: object[]): void {
    this.initialPolylines = polylines;
  }

  /**
   * 设置初始polygon数据
   * @param polygons polygon数组
   */
  setInitialPolygons(polygons: object[]): void {
    this.initialPolygons = polygons;
  }
}