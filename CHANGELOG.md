## 【3.1.2】 - 2026-07-07.
* 新增 HarmonyOS(ohos) 平台支持
* 在 `buildView` 中新增 `OhosView` 分支，viewType 为 `com.amap.flutter.map`
* 新增 `ohos/` 原生实现（ArkTS），参照 `csp_amap_flutter_map` 适配，MethodChannel 名为 `amap_flutter_map_${viewId}`
* 支持 Marker / Polyline / Polygon、相机控制、地图事件、审图号、清缓存、渲染帧率、比例尺等功能
* 配置说明详见 [HARMONYOS_SETUP.md](./HARMONYOS_SETUP.md)

## 【3.1.1】 - 2025-02-18.
* 升级Flutter 3.0.0以上版本，解决hashValues报错
* 解决 AAPT: error: resource android:attr/lStar not found报错
* 解决Namespace not specified.报错

## 【3.0.0】 - 2021-11-23.
* AMapWidget初始化时需要传入高德隐私合规配置参数privacyStatement
* 高德SDK合规使用方案请参考：https://lbs.amap.com/news/sdkhgsy
* 适配高德地图SDK 8.1.0及以后版本

## [2.0.2] - 2021-08-19.
* 修复在初始化地图时添加的Marker无法点击、移除的问题
* 修复在初始化地图时添加的Polyline无法点击、移除、修改的问题
* 修复在初始化地图时添加的Polygon无法点击、移除、修改的问题
## [2.0.1] - 2021-04-21.
* 支持Flutter 2.0.0以上版本
* 升级支持null-safety
* 修复2.0版本自定义地图样式不生效的问题
## [2.0.0] - 2021-04-21.
* 支持Flutter 2.0.0以上版本
* 升级支持null-safety
## [1.0.2] - 2021-02-02.
* debug模式，Android native端输出调试日志，方便排查问题。
## [1.0.1] - 2021-01-27.
* 修复iOS端动态库依赖静态库导致的pod install失败问题。
## [1.0.0] - 2020-12-22.
* 1.0.0版本发布