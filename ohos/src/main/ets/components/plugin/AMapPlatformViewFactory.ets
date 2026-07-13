import { Any, BinaryMessenger, MessageCodec, PlatformView, PlatformViewFactory } from "@ohos/flutter_ohos";
import { common } from "@kit.AbilityKit";
import { AMapOptionsBuilder } from "./AMapOptionsBuilder";
import { CommonUtils } from "./utils/CommonUtils";
import { ConvertUtil } from "./utils/ConvertUtil";
import { CameraPosition } from "@amap/amap_lbs_map3d";
import { display } from "@kit.ArkUI";
import {LogUtil} from './utils/LogUtil'
import { ArrayList } from "@kit.ArkTS";

/**
 * AMapPlatformViewFactory 地图平台视图工厂类，实现PlatformViewFactory接口。
 * 主要功能：
 * 1. 负责创建AMapPlatformView实例。
 * 2. 解析Flutter传递的参数，初始化地图参数（如apiKey、options、初始覆盖物等）。
 * 3. 支持隐私声明、调试模式等配置。
 */
export default class AMapPlatformViewFactory extends PlatformViewFactory {
  // Flutter消息通道
  message: BinaryMessenger;

  /**
   * 构造函数
   * @param message Flutter消息通道
   * @param createArgsCodes 参数编解码器
   */
  constructor(message: BinaryMessenger, createArgsCodes: MessageCodec<Object>) {
    super(createArgsCodes)
    this.message = message;
  }

  /**
   * 创建地图平台视图
   * @param context 上下文
   * @param viewId 视图ID
   * @param args Flutter传递的参数
   * @returns PlatformView
   */
  public create(context: common.Context, viewId: number, args: Any): PlatformView {
    // 构建地图参数Builder
    const builder: AMapOptionsBuilder = new AMapOptionsBuilder();
    // 解析apiKey
    let apiKey: Object = CommonUtils.argumentParse("apiKey", args)
    let ohosKey: string = CommonUtils.argumentParse("ohosKey", apiKey)
    let params: Map<String, Object> = args;
    LogUtil.i('AMapPlatformViewFactory',`AMapPlatformViewFactory：${viewId}`)

    // 设置屏幕密度
    ConvertUtil.density = display.getDefaultDisplaySync().densityPixels

    // 设置隐私声明
    if (params.has('privacyStatement')) {
      ConvertUtil.setPrivacyStatement(context, CommonUtils.argumentParse('privacyStatement', args))
    }
    // 解析地图options参数
    let options: Object = CommonUtils.argumentParse('options', args)
    if (options != undefined) {
      // 初始化信息保存在Builder里面
      ConvertUtil.interpretAMapOptions(options, builder);
    }
    // 设置初始相机位置
    if (params.has('initialCameraPosition')) {
      let cameraPosition: CameraPosition =
        ConvertUtil.toCameraPosition(CommonUtils.argumentParse('initialCameraPosition', args));
      builder.setCamera(cameraPosition);
    }
    // 设置初始marker
    if (params.has("markersToAdd")) {
      builder.setInitialMarkers(CommonUtils.argumentParse('markersToAdd', args));
    }
    // 设置初始polyline
    if (params.has("polylinesToAdd")) {
      builder.setInitialPolylines(CommonUtils.argumentParse('polylinesToAdd', args));
    }
    // 设置初始polygon
    if (params.has("polygonsToAdd")) {
      builder.setInitialPolygons(CommonUtils.argumentParse('polygonsToAdd', args));
    }

    // 校验apiKey
    if (params.has("apiKey")) {
      ConvertUtil.checkApiKey(apiKey);
    }
    // 设置调试模式
    if (params.has("debugMode")) {
      LogUtil.isDebugMode = ConvertUtil.toBoolean(CommonUtils.argumentParse('debugMode', args));
    }

    // 构建并返回地图平台视图
    return  builder.build(viewId, context, this.message);
  }
}