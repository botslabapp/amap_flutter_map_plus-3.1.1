import { LatLng } from '@amap/amap_lbs_map3d';
import { LogUtil } from './LogUtil';

export class Constants {
    public static ERROR = 1001; // 网络异常
    public static ROUTE_START_SEARCH = 2000;
    public static ROUTE_END_SEARCH = 2001;
    public static ROUTE_BUS_RESULT = 2002; // 路径规划中公交模式
    public static ROUTE_DRIVING_RESULT = 2003; // 路径规划中驾车模式
    public static ROUTE_WALK_RESULT = 2004; // 路径规划中步行模式
    public static ROUTE_NO_RESULT = 2005; // 路径规划没有搜索到结果

    public static GEOCODER_RESULT = 3000; // 地理编码或者逆地理编码成功
    public static GEOCODER_NO_RESULT = 3001; // 地理编码或者逆地理编码没有数据

    public static POISEARCH = 4000; // poi搜索到结果
    public static POISEARCH_NO_RESULT = 4001; // poi没有搜索到结果
    public static POISEARCH_NEXT = 5000; // poi搜索下一页

    public static BUSLINE_LINE_RESULT = 6001; // 公交线路查询
    public static BUSLINE_id_RESULT = 6002; // 公交id查询
    public static BUSLINE_NO_RESULT = 6003; // 异常情况

    public static BEIJING = new LatLng(39.90403, 116.407525); // 北京市经纬度
    public static ZHONGGUANCUN = new LatLng(39.983456, 116.3154950); // 北京市中关村经纬度
    public static SHANGHAI = new LatLng(31.238068, 121.501654); // 上海市经纬度
    public static FANGHENG = new LatLng(39.989614, 116.481763); // 方恒国际中心经纬度
    public static CHENGDU = new LatLng(30.679879, 104.064855); // 成都市经纬度
    public static XIAN = new LatLng(34.341568, 108.940174); // 西安市经纬度
    public static ZHENGZHOU = new LatLng(34.7466, 113.625367); // 郑州市经纬度

    public static MAP_SHOW_FUNC = '显示地图';
    public static MAP_MULTI_FUNC = '地图多实例';
    public static MAP_BOUND_LIMIT_FUNC = '限制显示区域';
    public static MAP_OVERLAY_ZINDEX_FUNC = '覆盖物层级功能';
    public static MAP_MARKER_FUNC = 'Marker功能';
    public static MAP_INFOWINDOW_FUNC = 'infowindow功能';
    public static MAP_POLYLINE_FUNC = 'Polyline功能';
    public static MAP_POLYGON_FUNC = 'Polygon功能';
    public static MAP_CIRCLE_FUNC = 'Circle功能';
    public static MAP_GL3DMODEL_FUNC = 'GL3DModel功能';
    public static MAP_MYLOCATION_FUNC = 'MyLocation功能';
    public static MAP_UISETTINGS_FUNC = 'UiSettings功能';
    public static MAP_GESTURE_FUNC = '手势功能';
    public static MAP_LAYER_FUNC = 'Layer图层功能';
    public static MAP_PROJECTION_FUNC = 'projection功能';
    public static MAP_CAMERA_UPDATE_FUNC = 'CamerUpdate功能';

    // 定义 ARGB 数值转十六进制函数
    public static argbToHex(argbNumber: number): number {
        // 提取各分量
        const alpha = (argbNumber >>> 24) & 0xFF; // 右移24位取高8位
        const red = (argbNumber >>> 16) & 0xFF;    // 右移16位取次高8位
        const green = (argbNumber >>> 8) & 0xFF;   // 右移8位取次低8位
        const blue = argbNumber & 0xFF;            // 直接取低8位

        // 拼接为十六进制字符串（如 "#FFD700FF"）
        const hexString = `#${alpha.toString(16).padStart(2, '0')}${red.toString(16).padStart(2, '0')}${green.toString(16).padStart(2, '0')}${blue.toString(16).padStart(2, '0')}`;
        // 将十六进制字符串转换为数值类型（如 0xFFD700FF）
        return parseInt(hexString.replace('#', ''), 16);
    }

    public static  rgbaStringToArgbInt(rgbaString: string): number {
        const match = rgbaString.match(/^rgba\((\d+(\.\d+)?),\s*(\d+(\.\d+)?),\s*(\d+(\.\d+)?)\s*,\s*(\d+(\.\d+)?)\)$/);
        if (!match) {
            throw new Error("Invalid RGBA string");
        }

        const r = Math.round(parseFloat(match[1]) * 255);
        const g = Math.round(parseFloat(match[3]) * 255);
        const b = Math.round(parseFloat(match[5]) * 255);
        const a = Math.round(parseFloat(match[7]) * 255);

        return ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
    }
}