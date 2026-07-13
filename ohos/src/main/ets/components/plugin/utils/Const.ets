// Const.ets
import { AMap, MapView } from "@amap/amap_lbs_map3d";
import { MethodResult } from "@ohos/flutter_ohos";
/**
 * 常量工具类
 * @author whm
 * @since 2020/11/10
 */
export class Const {
  /**
   * map 相关方法
   */
  static readonly METHOD_MAP_WAIT_FOR_MAP: string = "map#waitForMap";
  static readonly METHOD_MAP_CONTENT_APPROVAL_NUMBER: string = "map#contentApprovalNumber";
  static readonly METHOD_MAP_SATELLITE_IMAGE_APPROVAL_NUMBER: string = "map#satelliteImageApprovalNumber";
  static readonly METHOD_MAP_UPDATE: string = "map#update";
  static readonly METHOD_MAP_MOVE_CAMERA: string = "camera#move";
  static readonly METHOD_MAP_SET_RENDER_FPS: string = "map#setRenderFps";
  static readonly METHOD_MAP_TAKE_SNAPSHOT: string = "map#takeSnapshot";
  static readonly METHOD_MAP_CLEAR_DISK: string = "map#clearDisk";
  static readonly METHOD_MAP_GET_SCALE_PER_PIXEL: string = "map#getScalePerPixel";

  static readonly METHOD_ID_LIST_FOR_MAP: string[] = [
    Const.METHOD_MAP_CONTENT_APPROVAL_NUMBER,
    Const.METHOD_MAP_SATELLITE_IMAGE_APPROVAL_NUMBER,
    Const.METHOD_MAP_WAIT_FOR_MAP,
    Const.METHOD_MAP_UPDATE,
    Const.METHOD_MAP_MOVE_CAMERA,
    Const.METHOD_MAP_SET_RENDER_FPS,
    Const.METHOD_MAP_TAKE_SNAPSHOT,
    Const.METHOD_MAP_CLEAR_DISK,
    Const.METHOD_MAP_GET_SCALE_PER_PIXEL
  ];

  /**
   * markers 相关方法
   */
  static readonly METHOD_MARKER_UPDATE: string = "markers#update";
  static readonly METHOD_ID_LIST_FOR_MARKER: string[] = [Const.METHOD_MARKER_UPDATE];

  /**
   * polygons 相关方法
   */
  static readonly METHOD_POLYGON_UPDATE: string = "polygons#update";
  static readonly METHOD_ID_LIST_FOR_POLYGON: string[] = [Const.METHOD_POLYGON_UPDATE];

  /**
   * polylines 相关方法
   */
  static readonly METHOD_POLYLINE_UPDATE: string = "polylines#update";
  static readonly METHOD_ID_LIST_FOR_POLYLINE: string[] = [Const.METHOD_POLYLINE_UPDATE];


  static readonly MAP_VIEW = 'mapview'
  static readonly A_MAP = 'aMap'
  static readonly MAP_LOADED = 'mapLoaded'
  static readonly MAP_READY_RESULT = 'mapReadyResult'
  private static mapLoadedMap: Map<number, boolean> = new Map<number, boolean>();
  private static mapReadyResultMap: Map<number, MethodResult> = new Map<number, MethodResult>();

  private static aMapMap: Map<number, AMap> = new Map<number, AMap>();
  private static mapViewMap: Map<number, MapView> = new Map<number, MapView>();
  static LATITUDE: string = 'latitude';
  static LONGITUDE:string = 'longtitude'

  static getMapView(viewId?: number): MapView | undefined {
    if (viewId === undefined) {
      return AppStorage.get<MapView>(Const.MAP_VIEW);
    }
    return Const.mapViewMap.get(viewId);
  }

  static setMapView(value: MapView | undefined, viewId?: number) {
    if (viewId === undefined) {
      AppStorage.setOrCreate(Const.MAP_VIEW, value);
    } else {
      if (value) {
        Const.mapViewMap.set(viewId, value);
      } else {
        Const.mapViewMap.delete(viewId);
      }
    }
  }

  static getAMap(viewId?: number): AMap | undefined {
    if (viewId === undefined) {
      return AppStorage.get<AMap>(Const.A_MAP);
    }
    return Const.aMapMap.get(viewId);
  }

  static setAMap(value: AMap | undefined, viewId?: number) {
    if (viewId === undefined) {
      AppStorage.setOrCreate(Const.A_MAP, value);
    } else {
      if (value) {
        Const.aMapMap.set(viewId, value);
      } else {
        Const.aMapMap.delete(viewId);
      }
    }
  }

  static getMapLoaded(viewId?: number): boolean {
    if (viewId === undefined) {
      return AppStorage.get<boolean>(Const.MAP_LOADED) ?? false;
    }
    return Const.mapLoadedMap.get(viewId) ?? false;
  }

  static setMapLoaded(value: boolean, viewId?: number) {
    if (viewId === undefined) {
      AppStorage.setOrCreate(Const.MAP_LOADED, value);
    } else {
      Const.mapLoadedMap.set(viewId, value);
    }
  }

  static getLatitude() {
    return AppStorage.get<number>(Const.LATITUDE) ?? 39.909187;
  }

  static setLatitude(value: number) {
    AppStorage.setOrCreate(Const.LATITUDE, value)
  }

  static getLongitude() {
    return AppStorage.get<number>(Const.LONGITUDE) ?? 116.397451;
  }

  static setLongitude(value: number) {
    AppStorage.setOrCreate(Const.LONGITUDE, value)
  }

  static getMapReadyResult(viewId?: number): MethodResult | undefined {
    if (viewId === undefined) {
      return AppStorage.get<MethodResult>(Const.MAP_READY_RESULT);
    }
    return Const.mapReadyResultMap.get(viewId);
  }

  static setMapReadyResult(value: MethodResult | undefined, viewId?: number) {
    if (viewId === undefined) {
      AppStorage.setOrCreate(Const.MAP_READY_RESULT, value);
    } else {
      if (value) {
        Const.mapReadyResultMap.set(viewId, value);
      } else {
        Const.mapReadyResultMap.delete(viewId);
      }
    }
  }
}