import {
  AMap,
  BitmapDescriptorFactory,
  CameraPosition,
  CameraUpdateFactory,
  LatLng,
  MapsInitializer,
  MapView,
  MapViewComponent,
  MapViewCreateCallback,
  MapViewManager,
  Marker,
  MarkerOptions,
  MyLocationStyle,
  OnCameraChangeListener,
  OnLocationChangedListener,
  Poi,
  PolygonOptions
} from '@amap/amap_lbs_map3d'
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView'
import { AMapPlatformView } from './AMapPlatformView'
import { Const } from './utils/Const'
import common from '@ohos.app.ability.common'
import { LogUtil } from './utils/LogUtil'

/**
 * 地图组件，负责地图的生命周期管理与回调处理
 */
@Component
export struct AMapComponent {
  @Prop mParams: Params
  // 地图平台视图对象
  customView: AMapPlatformView = this.mParams.platformView as AMapPlatformView
  @StorageLink('numValue') storageLink: string = "first"
  @State bkColor: Color = Color.Red
  // 定位样式对象
  private locationStyle: MyLocationStyle = new MyLocationStyle();
  // 定时器ID
  private intervalId = 0;
  // 地图视图名称
  private mapViewName: string = "";

  /**
   * 更新定位样式
   * @param style 定位类型
   */
  public updateLocationStyle(style: number) {
    this.locationStyle.myLocationType(style);
    let aMap: AMap | undefined = Const.getAMap(this.customView.getViewId());
    aMap?.setMyLocationStyle(this.locationStyle);
  }

  /**
   * 组件即将显示时回调，注册地图创建回调
   */
  aboutToAppear(): void {
    this.mapViewName = `harmony_map_${this.customView.getViewId()}`;
    MapViewManager.getInstance().registerMapViewCreatedCallback(this.mapViewCreateCallback);
  }

  /**
   * 组件即将消失时回调，注销地图回调并释放资源
   */
  aboutToDisappear(): void {
    LogUtil.i('AMapComponent',`退出的时候ViewId：${this.customView.getViewId()}`)
    const viewId = this.customView.getViewId();
    let aMap: AMap | undefined = Const.getAMap(viewId);
    if (aMap) {
      aMap.setMyLocationEnabled(false);
    }
    if (this.mapViewCreateCallback) {
      MapViewManager.getInstance().unregisterMapViewCreatedCallback(this.mapViewCreateCallback);
    }
    let mapview = Const.getMapView(viewId);
    if (mapview) {
      mapview.onDestroy();
    }
    // 清理静态缓存
    Const.setMapView(undefined, viewId);
    Const.setAMap(undefined, viewId);
    Const.setMapLoaded(false,viewId);
  }

  /**
   * 地图视图创建回调
   * @param mapview 地图视图对象
   * @param mapViewName 地图视图名称
   */
  public mapViewCreateCallback: MapViewCreateCallback = (mapview?: MapView, mapViewName?: string) => {
    if (!mapview) {
      return;
    }
    if (mapViewName !== this.mapViewName) {
      return;
    }
    const viewId = this.customView.getViewId();
    LogUtil.i('AMapComponent',`mapViewCreateCallback viewId:${viewId}, mapViewName:${mapViewName}`)
    // 设置静态缓存
    Const.setMapView(mapview, viewId);
    mapview.onCreate();
    // 异步获取地图对象
    mapview.getMapAsync((map) => {
      Const.setAMap(map, viewId);
      Const.setMapLoaded(true, viewId);
      LogUtil.i('AMapComponent',`mapViewCreateCallback mapview.getMapAsync viewId:${viewId}, mapViewName:${mapViewName}`)
      let mapReadyResult = Const.getMapReadyResult(viewId);
      if (mapReadyResult != undefined) {
        console.error("waitForMap callback 2");
        mapReadyResult.success(null);
        Const.setMapReadyResult(undefined, viewId);
      }
      // 触发地图初始化完成事件
      (getContext(this) as common.UIAbilityContext).eventHub.emit(`onMapFinished_${viewId}`);
    });
  }

  /**
   * 构建地图组件视图
   */
  build() {
    Stack() {
      MapViewComponent({ mapViewName: this.mapViewName }).zIndex(0)
    }
    .direction(Direction.Ltr)
    .width('100%')
    .height('100%')
  }
}

/**
 * 地图组件Builder方法
 * @param params 参数
 */
@Builder
export function AMapBuilder(params: Params) {
  AMapComponent({ mParams: params })
}
