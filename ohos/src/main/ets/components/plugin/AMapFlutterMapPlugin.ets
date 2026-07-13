
import {
  Any,
  BasicMessageChannel,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodChannel,
  MethodResult,
  StandardMessageCodec
} from "@ohos/flutter_ohos";
import AMapPlatformViewFactory from "./AMapPlatformViewFactory";
import { hilog } from "@kit.PerformanceAnalysisKit";
/**
 * AMapFlutterMapPlugin 插件主入口，实现FlutterPlugin接口。
 * 主要功能：
 * 1. 插件注册与反注册，管理MethodChannel/BinaryMessenger。
 * 2. 注册AMapPlatformViewFactory到Flutter引擎，实现原生地图视图与Flutter的桥接。
 * 3. 负责插件生命周期管理。
 */

export default class AMapFlutterMapPlugin implements FlutterPlugin {
  /**
   * 插件从引擎解绑时回调，清理MethodChannel
   * @param binding 插件绑定对象
   */
  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.channel?.setMethodCallHandler(null)
  }

  // MethodChannel对象
  private channel?: MethodChannel;
  // 基础消息通道对象
  private basicChannel?: BasicMessageChannel<Any>;
  // 视图类型标识
  private VIEW_TYPE: string = "com.amap.flutter.map";
  // 插件绑定对象静态引用
  public static binding: FlutterPluginBinding;

  /**
   * 获取唯一类名
   * @returns 类名字符串
   */
  getUniqueClassName(): string {
    return "AMapFlutterMapPlugin"
  }

  /**
   * 插件绑定到引擎时回调，注册原生视图工厂
   * @param binding 插件绑定对象
   */
  onAttachedToEngine(binding: FlutterPluginBinding): void {
    AMapFlutterMapPlugin.binding = binding;
    binding.getPlatformViewRegistry().registerViewFactory(
      this.VIEW_TYPE,
      new AMapPlatformViewFactory(binding.getBinaryMessenger(), StandardMessageCodec.INSTANCE))
  }
}