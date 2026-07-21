part of '../amap_flutter_map_plus.dart';

/// 高德地图合规声明全局配置。
///
/// App 首次启动时通过
/// [updatePrivacyAgree] 传入高德合规声明，所有未显式传入 [AMapWidget.privacyStatement]
/// 的地图页面均回退使用此处设置的全局声明，避免每个页面重复传参、遗漏导致
/// SDK 隐私状态未初始化（鸿蒙端会抛 AMapPrivacyShowUnknow 崩溃）。
///
/// 本类只负责隐私声明，持有全局 _privacyStatement。内部调用时，如果没传值，会从这里获取一次。
class AMapInitializer {
  static AMapPrivacyStatement? _privacyStatement;

  AMapInitializer._();

  /// 在 App 首次启动时传入高德合规声明配置 [privacyStatement]，后续无变化不需重复设置。
  ///
  /// - [privacyStatement.hasContains] 隐私权政策是否包含高德开平隐私权政策
  /// - [privacyStatement.hasShow] 是否已经弹窗展示给用户
  /// - [privacyStatement.hasAgree] 隐私权政策是否已经取得用户同意
  ///
  /// 以上三个值任何一个为 false 都会造成地图插件不工作（白屏 / 隐私校验失败崩溃）。
  /// 高德 SDK 合规使用方案请参考：https://lbs.amap.com/news/sdkhgsy
  static void updatePrivacyAgree(AMapPrivacyStatement privacyStatement) {
    _privacyStatement = privacyStatement;
  }
}
