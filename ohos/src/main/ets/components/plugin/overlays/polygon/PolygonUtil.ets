import { LatLng } from "@amap/amap_lbs_map3d";
import { Any } from "@ohos/flutter_ohos";
import { ConvertUtil } from "../../utils/ConvertUtil";
import { PolygonOptionsSink } from "./PolygonOptionsSink";
export class PolygonUtil {
  static interpretOptions(obj: object,sink:PolygonOptionsSink) {
    const map: Map<string, Any> = obj as Map<string, Any>;

    // 设置点集合
    const points: Object | undefined = map.get('points');
    if (points !== undefined) {
      let pts = ConvertUtil.toPoints(points)
      let array:LatLng[]  = []
      pts.forEach((lat)=>{
        array.push(lat)
      })
      sink.setPoints(array);
    }

    // 设置边框颜色
    const strokeColor: Object | undefined = map.get('strokeColor');
    if (strokeColor !== undefined) {
      sink.setStrokeColor(ConvertUtil.toNumber(strokeColor));
    }

    // 设置填充颜色
    const fillColor: Object | undefined = map.get('fillColor');
    if (fillColor !== undefined) {
      sink.setFillColor(ConvertUtil.toNumber(fillColor));
    }

    // 设置边框宽度
    const strokeWidth: Object | undefined = map.get('strokeWidth');
    if (strokeWidth !== undefined) {
      sink.setStrokeWidth(ConvertUtil.toFloatPixels(strokeWidth));
    }

    // 设置Z轴指数
    const zIndex: Object | undefined = map.get('zIndex');
    if (zIndex !== undefined) {
      sink.setZIndex(ConvertUtil.toFloat(zIndex));
    }

    // 设置可见性
    const visible: Object | undefined = map.get('visible');
    if (visible !== undefined) {
      sink.setVisible(ConvertUtil.toBoolean(visible));
    }
    let polygonId:string|undefined = map.get('id')
    if (polygonId) {
      return polygonId
    }

    throw Error('PolygonUtil toPolygonOptions error')
  }

} 