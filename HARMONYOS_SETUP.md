# HarmonyOS(ohos) 平台配置指南

本文档介绍如何在 HarmonyOS 平台上配置和使用 `amap_flutter_map_plus` 插件。
ohos 平台实现参照了社区方案 `csp_amap_flutter_map`，并适配为 `amap_flutter_map_plus` 的方法通道契约。

## 🎯 前置要求

### 1. 开发环境要求
- **DevEco Studio**: 5.0 或以上版本
- **HarmonyOS Next**: API 12（compatibleSdkVersion `5.0.0(12)`）或以上
- **Flutter**: 需使用支持 ohos 的 Flutter SDK 分支（提供 `TargetPlatform.ohos` 与 `OhosView`）
- **高德地图 HarmonyOS SDK**:
  - `@amap/amap_lbs_map3d` >= 2.2.1
  - `@amap/amap_lbs_common` >= 1.2.0

### 2. 申请 API Key
1. 访问 [高德开放平台](https://lbs.amap.com/)
2. 登录并进入控制台
3. 创建 HarmonyOS 应用
4. 获取 HarmonyOS 平台的 API Key

## 🔧 插件如何接入

`amap_flutter_map_plus` 已在 `pubspec.yaml` 注册 ohos 平台：

```yaml
flutter:
  plugin:
    platforms:
      android:
        package: com.amap.flutter.map
        pluginClass: AMapFlutterMapPlugin
      ios:
        pluginClass: AMapFlutterMapPlugin
      ohos:
        package: com.amap.flutter.map
        pluginClass: AMapFlutterMapPlugin
```

- 原生插件入口：`ohos/index.ets` → `AMapFlutterMapPlugin`
- MethodChannel 名称：`amap_flutter_map_${viewId}`（与 Dart 端 `method_channel_amap_flutter_map.dart` 一致）
- PlatformView viewType：`com.amap.flutter.map`

依赖项见 `ohos/oh-package.json5`：
```json5
{
  "dependencies": {
    "@ohos/flutter_ohos": "file:./har/flutter.har",
    "@amap/amap_lbs_map3d": ">=2.2.1",
    "@amap/amap_lbs_common": ">=1.2.0"
  }
}
```
> `@ohos/flutter_ohos` 与本插件打包出的 `amap_flutter_map_plus.har` 由 Flutter ohos 构建工具（`flutter build hap`）生成并放置到 `example/ohos/har/` 下，无需手动管理。

## 🔑 API Key 配置（重要）

ohos 原生端通过两种方式获取 API Key：

### 方式一（推荐）：通过 `AMapApiKey.ohosKey` 传入

Dart 侧 `AMapWidget(apiKey: AMapApiKey(...))` 会被序列化为 `creationParams['apiKey']`，原生端 `ConvertUtil.checkApiKey` 从中读取 `ohosKey` 字段并调用 `MapsInitializer.setApiKey(aKey)`。

```dart
AMapWidget(
  apiKey: AMapApiKey(
    androidKey: 'your_android_key',
    iosKey: 'your_ios_key',
    ohosKey: 'your_harmonyos_key', // 鸿蒙 Key
  ),
  ...
)
```

> ⚠️ **依赖说明**：`AMapApiKey` 来自 `amap_flutter_base_plus` 包。需要该包的 `AMapApiKey` 构造函数支持 `ohosKey` 参数，且 `toMap()` 输出包含 `ohosKey` 字段，鸿蒙端才能拿到 Key。
> 若你使用的 `amap_flutter_base_plus` 版本不含 `ohosKey`，请：
> - 升级/扩展 `amap_flutter_base_plus` 的 `AMapApiKey` 增加 `ohosKey` 字段；或
> - 改用方式二。

### 方式二（兜底）：在 `module.json5` 配置 metadata

在宿主工程的 `module.json5` 中配置：
```json5
{
  "module": {
    "metadata": [
      {
        "name": "AMap_api_key",
        "value": "your_harmonyos_api_key_here"
      }
    ]
  }
}
```
> 注意：当前原生实现优先读取方式一的 `ohosKey`。若需原生端改为读取 metadata，可在 `ohos/src/main/ets/components/plugin/utils/ConvertUtil.ets` 的 `checkApiKey` 中扩展读取逻辑。

## 🔒 权限配置

在宿主工程 `entry/src/main/module.json5` 的 `requestPermissions` 中按需添加：
```json5
"requestPermissions": [
  { "name": "ohos.permission.INTERNET" },
  { "name": "ohos.permission.APPROXIMATELY_LOCATION" },
  { "name": "ohos.permission.LOCATION" }
]
```
- 仅显示地图：`INTERNET` 即可。
- 定位蓝点：需 `APPROXIMATELY_LOCATION` / `LOCATION`，且需运行时动态申请。

## 📱 使用示例

```dart
import 'package:flutter/material.dart';
import 'package:amap_flutter_map_plus/amap_flutter_map_plus.dart';
import 'package:amap_flutter_base_plus/amap_flutter_base_plus.dart';

class HarmonyOSMapPage extends StatefulWidget {
  @override
  _HarmonyOSMapPageState createState() => _HarmonyOSMapPageState();
}

class _HarmonyOSMapPageState extends State<HarmonyOSMapPage> {
  late AMapController _mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(39.909187, 116.397451),
    zoom: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HarmonyOS 地图示例')),
      body: AMapWidget(
        apiKey: AMapApiKey(
          androidKey: 'your_android_key',
          iosKey: 'your_ios_key',
          ohosKey: 'your_harmonyos_key',
        ),
        initialCameraPosition: _initialPosition,
        onMapCreated: (AMapController controller) {
          _mapController = controller;
        },
        onTap: (LatLng latLng) {
          print('点击位置: ${latLng.latitude}, ${latLng.longitude}');
        },
      ),
    );
  }
}
```

## 🚀 功能支持情况

### ✅ 已支持
- ✅ 地图显示和基础操作
- ✅ 相机控制（移动、缩放、旋转、倾斜）`camera#move`
- ✅ 标记 (Marker) 添加和管理 `markers#update`
- ✅ 折线 (Polyline) 绘制 `polylines#update`
- ✅ 多边形 (Polygon) 绘制 `polygons#update`
- ✅ 地图事件监听：点击 `map#onTap`、长按 `map#onLongPress`、相机移动 `camera#onMove`/`camera#onMoveEnd`、POI 点击 `map#onPoiTouched`、定位回调 `location#changed`
- ✅ 地图审图号（普通 `map#contentApprovalNumber` / 卫星 `map#satelliteImageApprovalNumber`）
- ✅ 清空缓存 `map#clearDisk`
- ✅ 设置渲染帧率 `map#setRenderFps`
- ✅ 获取比例尺 `map#getScalePerPixel`

### 🔄 待完善
- 🔄 `map#takeSnapshot` 截图：ohos 端目前为占位实现（返回 null）
- 🔄 `marker#onTap` / `marker#onDragEnd` / `polyline#onTap` 事件：ohos 原生端 `MapController.afterInit` 暂未注册这些回调的发送。Dart 端已监听，如需启用可在 `MarkersController`/`PolylinesController` 中补充点击监听并 `methodChannel.invokeMethod(...)`。

## 🐛 故障排除

### 地图不显示 / 白屏
- 检查 API Key 是否正确配置（`ohosKey` 或 metadata）。
- 检查 `ohos.permission.INTERNET` 是否已获取。
- 检查高德合规声明 `privacyStatement` 是否传入（hasContains/hasShow/hasAgree 任一为 false 会白屏）。
- 查看 hilog 日志（TAG: `AMapMap`），开启调试：`LogUtil.isDebugMode`。

### 定位蓝点不显示
- 确认已申请 `LOCATION` / `APPROXIMATELY_LOCATION` 权限并运行时授权。
- 确认 `myLocationStyleOptions.enabled = true`。

## 📄 许可证
本项目基于 Apache License 2.0 许可证开源。详见 [LICENSE](../LICENSE) 文件。
