import {
  AMap,
  BitmapDescriptor,
  BitmapDescriptorFactory,
  CameraPosition,
  CameraUpdate,
  CameraUpdateFactory,
  CustomMapStyleOptions,
  LatLng,
  LatLngBounds,
  MapsInitializer,
  MapType,
  MyLocationStyle,
  Poi,
  Point
} from '@amap/amap_lbs_map3d';
import {
  AMapPrivacyAgreeStatus,
  AMapPrivacyInfoStatus,
  AMapPrivacyShowStatus
} from '@amap/amap_lbs_common';
import { Any, FlutterComponent, FlutterInjector, FlutterManager, FlutterPage, FlutterView } from '@ohos/flutter_ohos';
import { AMapOptionsSink } from '../core/AMapOptionsSink';
import { image } from '@kit.ImageKit';
import { Const } from './Const';
import AMapFlutterMapPlugin from '../AMapFlutterMapPlugin';
import { ArrayList } from '@kit.ArkTS';
import { LogUtil } from './LogUtil';
import { Constants } from './Constants';
import { geoLocationManager } from '@kit.LocationKit';

export class ConvertUtil {
  static CLASS_NAME: string = 'ConvertUtil'
  static density: number = 1
  static apiKey: string

  static setPrivacyStatement(context: Context, object: Any) {
    if (context === null || context === undefined || object === null || object === undefined) {
      return;
    }
    const map: Map<String, Object> = object as Map<String, Object>
    let hasContains: boolean = false
    let hasShow: boolean = false
    let hasAgree: boolean = false
    if (map.has('hasContains')) {
      hasContains = ConvertUtil.toBoolean(map.get('hasContains')!);
    }
    if (map.has('hasShow')) {
      hasShow = ConvertUtil.toBoolean(map.get('hasShow')!)
    }
    if (map.has('hasAgree')) {
      hasAgree = ConvertUtil.toBoolean(map.get('hasAgree')!)
    }

    const showStatus: AMapPrivacyShowStatus = hasShow
      ? AMapPrivacyShowStatus.DidShow
      : AMapPrivacyShowStatus.NotShow
    const infoStatus: AMapPrivacyInfoStatus = hasContains
      ? AMapPrivacyInfoStatus.DidContain
      : AMapPrivacyInfoStatus.NotContain
    const agreeStatus: AMapPrivacyAgreeStatus = hasAgree
      ? AMapPrivacyAgreeStatus.DidAgree
      : AMapPrivacyAgreeStatus.NotAgree

    MapsInitializer.updatePrivacyShow(showStatus, infoStatus, context)
    MapsInitializer.updatePrivacyAgree(agreeStatus, context)
    LogUtil.i(ConvertUtil.CLASS_NAME,
      `setPrivacyStatement hasContains:${hasContains}, hasShow:${hasShow}, hasAgree:${hasAgree}`)
  }

  static checkApiKey(object: Any): void {
    if (object === null || object === undefined) {
      return;
    }

    const keyObject: Any = object.get("ohosKey");

    if (keyObject !== null && keyObject !== undefined) {
      const aKey: string = ConvertUtil.toString(keyObject); // 确保toString函数已定义
      if (!aKey || aKey.trim() === '' || ConvertUtil.apiKey === null || ConvertUtil.apiKey === undefined ||
        aKey !== ConvertUtil.apiKey) {
        ConvertUtil.apiKey = aKey;
        MapsInitializer.setApiKey(aKey); // 确保MapsInitializer.setApiKey已定义
      }
    }
  }



  static toLocalMapType(dartMapIndex: number): number {
    const localTypeArray: number[] = [
      MapType.MAP_TYPE_NORMAL,
      MapType.MAP_TYPE_SATELLITE,
      MapType.MAP_TYPE_NIGHT,
      MapType.MAP_TYPE_NAVI,
      MapType.MAP_TYPE_BUS
    ];

    // 增强型安全校验（包含原始逻辑修复）
    if (
      dartMapIndex < 0 || // 处理负数索引
        dartMapIndex >= localTypeArray.length    // 修复原代码的越界问题
    ) {
      return localTypeArray[0]; // 返回默认值
    }

    return localTypeArray[dartMapIndex];
  }

  static toCameraUpdate(o: Object): CameraUpdate {
    let data: Any[] = ConvertUtil.toList(o);
    switch (ConvertUtil.toString(data[0])) {
      case 'newCameraPosition':
        let lat_long: Any[] = data[1].get("target")
        let latitude: number = lat_long[0]
        let longitude: number = lat_long[1]
        Const.setLatitude(latitude)
        Const.setLongitude(longitude)
        return CameraUpdateFactory.newCameraPosition(ConvertUtil.toCameraPosition(data[1]))
      case 'newLatLng':
        return CameraUpdateFactory.newLatLng(ConvertUtil.toLatLng(data[1]));
      case "newLatLngBounds":
        return CameraUpdateFactory.newLatLngBounds(
          ConvertUtil.toLatLngBounds(data[1]), ConvertUtil.toPixels(data[2]));
      case "newLatLngZoom":
        return CameraUpdateFactory.newLatLngZoom(ConvertUtil.toLatLng(data[1]), ConvertUtil.toFloat(data[2]))
      case "scrollBy":
          return CameraUpdateFactory.scrollBy(ConvertUtil.toFloatPixels(data[1]),ConvertUtil.toFloatPixels(data[2]))
      case "zoomBy":
        if (data.length === 2) {
          return CameraUpdateFactory.zoomBy(ConvertUtil.toFloat(data[1]))
        }else{
          return CameraUpdateFactory.zoomBy(ConvertUtil.toFloat(data[1]),ConvertUtil.toPoint(data[2]))
        }
      case "zoomIn":
        return CameraUpdateFactory.zoomIn()
      case "zoomOut":
        return CameraUpdateFactory.zoomOut()
      case "zoomTo":
        return CameraUpdateFactory.zoomTo(ConvertUtil.toFloat(data[1]))
      default:
        throw new Error("Cannot interpret " + o + " as CameraUpdate");
    }
  }

  static toList(o: Any): [] {
    if (typeof o == 'object') {
      return o as []
    }
    return []
  }

  static toInt32List(o: Any): Int32Array {
    const array:Array<Any> = o as Array<Any>
    return Int32Array.of(...array)
  }

  static toString(o: Object): string {
    if (typeof o == 'string') {
      return o as string;
    }
    return ''
  }
  static toInt(o: Object | undefined): number {
    if (o == undefined) {
      return 0;
    }
    if (typeof o == 'number') {
      return Math.floor((o as number));
    }
    return 0;
  }
  static toFloat(o: Object | undefined): number {
    if (o == undefined) {
      return 0;
    }
    if (typeof o == 'number') {
      return o as number;
    }
    return 0;
  }

  static toNumber(o: Object): number {
    if (typeof o == 'number') {
      return o as number;
    }
    return 0;
  }

  static toBoolean(o: Object): boolean {
    if (typeof o == 'boolean') {
      return o as boolean;
    }
    return false;
  }

  static toPixels(o: Object): number {
    if (typeof o == 'number') {
      return o as number;
    }
    return 0;
  }
  static poiToMap(poi:Poi){
    if (!poi) {
      return null
    }
    const coordinate = poi.getCoordinate()
    if (!coordinate) {
      return null
    }
    let obj:Map<string,Any> = new Map()
    obj.set('id',poi.getPoiId())
    obj.set('name',poi.getName())
    obj.set('latLng',[coordinate.latitude, coordinate.longitude])
    return obj
  }

  static toLatLng(o: Any): LatLng {
    const data: Any[] = Array.isArray(o) ? o : [];
    if (data.length < 2 || typeof data[0] !== 'number' || typeof data[1] !== 'number') {
      throw new Error('Invalid input format for LatLng conversion');
    }
    return new LatLng(data[0], data[1]);
  }

  static toLatLngBounds(o: Any): LatLngBounds | undefined {
    if (o == null) {
      return undefined;
    }
    let data: Any[] = ConvertUtil.toList(o);
    if (data.length < 2) {
      throw new Error('Input list must contain at least two elements for LatLngBounds conversion');
    }
    return new LatLngBounds(ConvertUtil.toLatLng(data[0]), ConvertUtil.toLatLng(data[1]));
  }

  static toCameraPosition(o: Object) {
    let data: Map<Any, Any> = o as Map<Any, Any>;
    LogUtil.i('ConvertUtil',`target:${ConvertUtil.toLatLng(data.get("target")).latitude}:${ConvertUtil.toLatLng(data.get("target")).longitude}`)
    let builder = CameraPosition.builder();
    builder.bearing(ConvertUtil.toFloat(data.get("bearing")))
    builder.target(ConvertUtil.toLatLng(data.get("target")))
    builder.tilt(ConvertUtil.toFloat(data.get("tilt")))
    builder.zoom(ConvertUtil.toFloat(data.get("zoom")))
    return builder.build();
  }

  static toPoint(o: Object): Point {
    let data: Any[] = ConvertUtil.toList(o)
    return new Point(ConvertUtil.toPixels(data[0]), ConvertUtil.toPixels(data[1]))
  }
  static toPoints(o: Object): ArrayList<LatLng> {
    let data: Any[] = ConvertUtil.toList(o)
    let array: ArrayList<LatLng> = new ArrayList()
    data.forEach((value:Any)=>{
      const list:Any[] = ConvertUtil.toList(value)
      array.add(new LatLng(ConvertUtil.toPixels(list[0]), ConvertUtil.toPixels(list[1])))
    })
    return array
  }
  static toFloatPixels(o: Object): number {
    return ConvertUtil.toFloat(o) * ConvertUtil.density
  }
  static location2Map(location:geoLocationManager.Location){
    if (!location) {
      return null
    }
    if (location.altitude > 90 || location.altitude < -90 || location.longitude > 180 || location.longitude < -180) {
      return null
    }
    let obj:Map<string,Any> = new Map()
    obj.set('latLng',[location.latitude,location.longitude])
    obj.set('accuracy',location.accuracy)
    obj.set('altitude',location.altitude)
    obj.set('bearing',location.direction)
    obj.set('speed',location.speed)
    obj.set('time',location.timeStamp)
    return obj
  }

  static cameraPositionToMap(position: CameraPosition | undefined): Object | undefined {
    if (position == undefined) {
      return undefined
    }
    let data = new Map<string, Object>()
    data.set('bearing', position.bearing)
    data.set('target', [position.target.latitude,position.target.longitude])
    data.set('tilt', position.tilt)
    data.set('zoom', position.zoom)
    return data
  }

  static async interpretAMapOptions(obj: object, sink: AMapOptionsSink): Promise<void> {
    try {

      let data: Map<Any, Any> = obj as Map<Any, Any>;

      let mapType: object = data.get('mapType');

      if (mapType !== undefined) {
        sink.setMapType(ConvertUtil.toLocalMapType(ConvertUtil.toFloat(mapType)));
      }

      // 处理 buildingsEnabled
      const buildingsEnabled: object = data.get('buildingsEnabled');
      if (buildingsEnabled !== undefined) {
        sink.setBuildingsEnabled(ConvertUtil.toBoolean(buildingsEnabled));
      }

      // 处理 customStyleOptions
      const customStyleOptions: object = data.get('customStyleOptions');
      if (customStyleOptions !== undefined) {
        sink.setCustomMapStyleOptions(ConvertUtil.toCustomMapStyleOptions(customStyleOptions));
      }

      // 处理 myLocationStyle
      const myLocationStyleData: object = data.get('myLocationStyle');
      if (myLocationStyleData !== undefined) {
        sink.setMyLocationStyle(await ConvertUtil.toMyLocationStyle(myLocationStyleData, ConvertUtil.density));
      }

      // 处理 screenAnchor
      const screenAnchor: object = data.get('screenAnchor');
      if (screenAnchor !== undefined) {
        const anchorData: Any[] = ConvertUtil.toList(screenAnchor);
        if (anchorData.length >= 2) {
          const x = ConvertUtil.toFloat(anchorData[0]);
          const y = ConvertUtil.toFloat(anchorData[1]);
          sink.setScreenAnchor(x, y);
        }
      }

      // 处理 compassEnabled
      const compassEnabled: object = data.get('compassEnabled');
      if (compassEnabled !== undefined) {
        sink.setCompassEnabled(ConvertUtil.toBoolean(compassEnabled));
      }

      // 处理 labelsEnabled
      const labelsEnabled: object = data.get('labelsEnabled');
      if (labelsEnabled !== undefined) {
        sink.setLabelsEnabled(ConvertUtil.toBoolean(labelsEnabled));
      }

      // 处理 limitBounds
      const limitBounds: object = data.get('limitBounds');
      if (limitBounds !== undefined) {
        const targetData:Any[] = ConvertUtil.toList(limitBounds);
        const result = ConvertUtil.toLatLngBounds(targetData)
        if (result != undefined) {
          sink.setLatLngBounds(result);
        }
      }

      // 处理 minMaxZoomPreference
      const minMaxZoomPreference: object = data.get('minMaxZoomPreference');
      if (minMaxZoomPreference !== undefined) {
        const targetData: Any[] = ConvertUtil.toList(minMaxZoomPreference);
        if (targetData.length >= 2) {
          sink.setMinZoomLevel(ConvertUtil.toFloatWrapperWithDefault(targetData[0], 3));
          sink.setMaxZoomLevel(ConvertUtil.toFloatWrapperWithDefault(targetData[1], 20));
        }
      }

      // 处理 scaleEnabled
      const scaleEnabled: object = data.get('scaleEnabled');
      if (scaleEnabled !== undefined) {
        sink.setScaleEnabled(ConvertUtil.toBoolean(scaleEnabled));
      }

      // 处理 touchPoiEnabled
      const touchPoiEnabled: object = data.get('touchPoiEnabled');
      if (touchPoiEnabled !== undefined) {
        LogUtil.i(ConvertUtil.CLASS_NAME,`${typeof touchPoiEnabled},${ConvertUtil.toBoolean(touchPoiEnabled)}`)
        sink.setTouchPoiEnabled(ConvertUtil.toBoolean(touchPoiEnabled));
      }

      // 处理 trafficEnabled
      const trafficEnabled: object = data.get('trafficEnabled');
      if (trafficEnabled !== undefined) {
        sink.setTrafficEnabled(ConvertUtil.toBoolean(trafficEnabled));
      }

      // 处理 rotateGesturesEnabled
      const rotateGesturesEnabled: object = data.get('rotateGesturesEnabled');
      if (rotateGesturesEnabled !== undefined) {
        sink.setRotateGesturesEnabled(ConvertUtil.toBoolean(rotateGesturesEnabled));
      }

      // 处理 scrollGesturesEnabled
      const scrollGesturesEnabled: object = data.get('scrollGesturesEnabled');
      if (scrollGesturesEnabled !== undefined) {
        sink.setScrollGesturesEnabled(ConvertUtil.toBoolean(scrollGesturesEnabled));
      }

      // 处理 tiltGesturesEnabled
      const tiltGesturesEnabled: object = data.get('tiltGesturesEnabled');
      if (tiltGesturesEnabled !== undefined) {
        sink.setTiltGesturesEnabled(ConvertUtil.toBoolean(tiltGesturesEnabled));
      }

      // 处理 zoomGesturesEnabled
      const zoomGesturesEnabled: object = data.get('zoomGesturesEnabled');
      if (zoomGesturesEnabled !== undefined) {
        sink.setZoomGesturesEnabled(ConvertUtil.toBoolean(zoomGesturesEnabled));
      }

    } catch (error) {
      console.error("[AMap] interpretAMapOptions error:", error);
    }
  }

  static toCustomMapStyleOptions(obj: object): CustomMapStyleOptions {
    // 类型安全检查
    if (!obj || typeof obj !== "object" || Array.isArray(obj)) {
      throw new TypeError("Invalid input: expected an object");
    }

    const map: Map<Any, Any> = obj as Map<Any, Any>;
    const customMapStyleOptions: CustomMapStyleOptions = new CustomMapStyleOptions()
    const enableData: object = map.get('enabled')
    if (enableData !== undefined) {
      customMapStyleOptions.setEnable(ConvertUtil.toBoolean(enableData))
    }

    const styleData: object = map.get('styleData');
    if (styleData !== undefined) {
      customMapStyleOptions.setStyleId(ConvertUtil.toString(styleData))
    }

    return customMapStyleOptions;
  }

  static async toMyLocationStyle(obj: object, density: number): Promise<MyLocationStyle> {
    const map: Map<Any, Any> = obj as Map<Any, Any>
    const myLocationStyle: MyLocationStyle = new MyLocationStyle()
    const enableData: object = map.get('enabled')
    if (enableData != undefined) {
      LogUtil.i(ConvertUtil.CLASS_NAME,`toMyLocationStyle enabled:${ConvertUtil.toBoolean(enableData)}`)
      myLocationStyle.showMyLocation(ConvertUtil.toBoolean(enableData))
    }
    myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_FOLLOW_NO_CENTER)

    const circleFillColorData: object = map.get('circleFillColor')
    if (circleFillColorData != undefined) {
      LogUtil.i(ConvertUtil.CLASS_NAME,`toMyLocationStyle circleFillColor:${Constants.argbToHex(ConvertUtil.toNumber(circleFillColorData))}`)
      myLocationStyle.radiusFillColor(Constants.argbToHex(ConvertUtil.toNumber(circleFillColorData)))
    }

    const circleStrokeColorData: object = map.get('circleStrokeColor')
    if (circleStrokeColorData != undefined) {
      LogUtil.i(ConvertUtil.CLASS_NAME,`toMyLocationStyle circleStrokeColor:${Constants.argbToHex(ConvertUtil.toNumber(circleStrokeColorData))}`)
      myLocationStyle.strokeColor(Constants.argbToHex(ConvertUtil.toNumber(circleStrokeColorData)))
    }

    const circleStrokeWidthData: object = map.get('circleStrokeWidth')
    if (circleStrokeWidthData != undefined) {
      LogUtil.i(ConvertUtil.CLASS_NAME,`toMyLocationStyle circleStrokeWidth:${ConvertUtil.toNumber(circleStrokeWidthData)}`)
      myLocationStyle.strokeWidth(ConvertUtil.toNumber(circleStrokeWidthData))
    }

    const iconDta: object = map.get('icon');
    if (iconDta != undefined) {
      LogUtil.i(ConvertUtil.CLASS_NAME,`toMyLocationStyle iconDta:${iconDta}`)
      let icon = await ConvertUtil.toBitmapDescriptor(iconDta)
      myLocationStyle.myLocationIcon(icon);
    }

    return myLocationStyle;
  }
  static async toBitmapDescriptorList(obj:object):Promise<ArrayList<BitmapDescriptor>|undefined>{
    const rawList:Any[] = ConvertUtil.toList(obj)
    const bitmapList:ArrayList<BitmapDescriptor> = new ArrayList()
    rawList.forEach(async (value:Any)=>{
      const bit = await ConvertUtil.toBitmapDescriptor(value)
      bitmapList.add(bit)
    })
    return bitmapList
  }

  static async toBitmapDescriptor(obj: object): Promise<BitmapDescriptor | undefined> {
    const data: Any[] = ConvertUtil.toList(obj)
    let flutterLoader = FlutterInjector.getInstance().getFlutterLoader();
    let rmg = AMapFlutterMapPlugin.binding.getApplicationContext().resourceManager;
    switch (ConvertUtil.toString(data[0])) {
      case 'defaultMarker':
        if (data.length == 1) {
          return BitmapDescriptorFactory.defaultMarker();
        } else {
          return BitmapDescriptorFactory.defaultMarker(ConvertUtil.toNumber(data))
        }

      case 'fromAsset':
        if (data.length == 2) {
          const s1 = ConvertUtil.toString(data[1])
          const assetName: string = flutterLoader.getLookupKeyForAsset(s1)
          let rawfile = await rmg.getRawFileContent(assetName);
          let buffer = rawfile.buffer.slice(0);
          return await BitmapDescriptorFactory.fromPixelMap(image.createImageSource(buffer).createPixelMapSync());
        } else {
          const s1 = ConvertUtil.toString(data[1])
          const s2 = ConvertUtil.toString(data[2])
          const assetName: string = flutterLoader.getLookupKeyForAsset(s1, s2)
          let rawfile = await rmg.getRawFileContent(assetName);
          let buffer = rawfile.buffer.slice(0);
          return await BitmapDescriptorFactory.fromPixelMap(image.createImageSource(buffer).createPixelMapSync());
        }

      case 'fromAssetImage':
        if (data.length == 3) {
          const s1 = ConvertUtil.toString(data[1])
          const assetName: string = flutterLoader.getLookupKeyForAsset(s1)
          let rawfile = await rmg.getRawFileContent(assetName);
          let buffer = rawfile.buffer.slice(0);
          let result: BitmapDescriptor | undefined;
          result = await BitmapDescriptorFactory.fromPixelMap(image.createImageSource(buffer).createPixelMapSync());
          return result
        } else {
          throw new Error("'fromAssetImage' Expected exactly 3 arguments, got: " + data.length)
        }

      case 'fromBytes':
        return ConvertUtil.getBitmapFromBytes(data);

      default:
        throw new Error("Cannot interpret " + obj + " as BitmapDescriptor")
    }
  }

  static getBitmapFromBytes(data: Any[]): BitmapDescriptor | undefined {
    if (data.length == 2) {
      try {
        return BitmapDescriptorFactory.fromPixelMapSync(ConvertUtil.toBitmap(data[1]))
      } catch (e) {
        throw new Error('Unable to interpret bytes as a valid image.' + e)
      }
    } else {
      throw new Error('fromBytes should have exactly one argument, the bytes. Got: ' + data.length)
    }
  }

  static toBitmap(obj: object): PixelMap {
    try {
      // 1. 首先打印调试信息
      console.info(`[toBitmap] 接收数据类型: ${typeof obj}`);
      
      // 2. 转换为字节数组，类似于安卓的 byte[] bmpData = (byte[]) o;
      let byteArray: number[] | Uint8Array;
      if (obj instanceof Uint8Array) {
        byteArray = obj;
        console.info(`[toBitmap] 数据是Uint8Array类型，长度: ${byteArray.length}`);
      } else if (Array.isArray(obj)) {
        byteArray = obj as number[];
        console.info(`[toBitmap] 数据是数组类型，长度: ${byteArray.length}`);
      } else {
        // 如果不是预期的类型，抛出错误
        console.error(`[toBitmap] 数据类型错误，无法转换为字节数组: ${typeof obj}`);
        throw new Error("无法将数据转换为字节数组");
      }
      
      // 3. 检查字节数组是否有效
      if (!byteArray || byteArray.length === 0) {
        console.error(`[toBitmap] 字节数组为空或长度为0`);
        throw new Error("字节数组为空或长度为0");
      }
      
      console.info(`[toBitmap] 字节数组有效，长度: ${byteArray.length}`);
      
      // 4. 确保数据是Uint8Array格式
      const uint8Array = (byteArray instanceof Uint8Array) ? 
          byteArray : new Uint8Array(byteArray);
      
      // 5. 创建ImageSource - 类似安卓的BitmapFactory
      const imageSource = image.createImageSource(uint8Array.buffer);
      if (!imageSource) {
        console.error(`[toBitmap] 无法创建图像源`);
        throw new Error("无法创建图像源");
      }
      
      // 6. 设置解码选项
      const options: image.DecodingOptions = {
        desiredSize: { width: 0, height: 0 }, // 使用原始尺寸
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888
      };
      
      // 7. 解码图像 - 类似安卓的decodeByteArray
      const pixelMap = imageSource.createPixelMapSync(options);
      if (!pixelMap) {
        console.error(`[toBitmap] 无法解码字节数组为有效图像`);
        throw new Error("无法解码字节数组为有效图像");
      }
      
      // 8. 打印成功信息
      const imageInfo = pixelMap.getImageInfoSync();
      console.info(`[toBitmap] 成功解码图像，尺寸: ${imageInfo.size.width}x${imageInfo.size.height}`);
      
      return pixelMap;
    } catch (error) {
      console.error(`[toBitmap] 错误: ${error}`);
      throw new Error(`无法将字节解码为有效图像: ${error}`);
    }
  }

  static toFloatWrapperWithDefault(obj: object, defaultValue: number): number {
    return (obj == undefined) ? defaultValue : ConvertUtil.toFloat(obj);
  }
}