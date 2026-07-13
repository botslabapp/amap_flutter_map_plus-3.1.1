import { CameraPosition, CustomMapStyleOptions, LatLngBounds, MyLocationStyle } from '@amap/amap_lbs_map3d';


// 主接口定义
export interface AMapOptionsSink {
  // 相机位置
  setCamera(camera: CameraPosition): void;

  // 地图类型（普通、卫星等）
  setMapType(mapType: number): void;

  // 自定义地图样式
  setCustomMapStyleOptions(options: CustomMapStyleOptions): void;

  // 定位样式
  setMyLocationStyle(style: MyLocationStyle): void;

  // 屏幕锚点坐标（比例值，范围0~1）
  setScreenAnchor(x: number, y: number): void;

  // 缩放范围控制
  setMinZoomLevel(minZoomLevel: number): void;

  setMaxZoomLevel(maxZoomLevel: number): void;

  // 地理区域限制
  setLatLngBounds(bounds: LatLngBounds): void;

  // 图层控制
  setTrafficEnabled(enabled: boolean): void;

  setTouchPoiEnabled(enabled: boolean): void;

  setBuildingsEnabled(enabled: boolean): void;

  setLabelsEnabled(enabled: boolean): void;

  // 控件显示
  setCompassEnabled(enabled: boolean): void;

  setScaleEnabled(enabled: boolean): void;

  // 手势交互控制
  setZoomGesturesEnabled(enabled: boolean): void;

  setScrollGesturesEnabled(enabled: boolean): void;

  setRotateGesturesEnabled(enabled: boolean): void;

  setTiltGesturesEnabled(enabled: boolean): void;

  // 覆盖物初始化（使用具体类型替代any）
  setInitialMarkers(markers: object[]): void; // Marker[]
  setInitialPolylines(polylines: object[]): void; // Polyline[]
  setInitialPolygons(polygons: object[]): void; // Polygon[]
}
