import { Any } from "@ohos/flutter_ohos"
import { Constants } from "../../utils/Constants";
import { ConvertUtil } from "../../utils/ConvertUtil";
import { LogUtil } from "../../utils/LogUtil";
import { PolylineOptionsSink } from "./PolylineOptionsSink"

export class PolylineUtil{
  private static CLASS_NAME = 'PolylineUtil'
  private static DASH_LINE_TYPE = [-1,0,1]

  static async interpretOptions(obj:Object,sink:PolylineOptionsSink): Promise<string | undefined>{
    if (obj == undefined) {
      return undefined;
    }

    const data: Map<string | number, Any> = obj as Map<string | number, Any>;

    const points: Object | undefined = data.get('points');
    if (points != undefined) {
      const pts = ConvertUtil.toPoints(points)
      pts.forEach((value)=>{
        LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的经纬度：${value.toString()}`)
      })
      sink.setPoints(ConvertUtil.toPoints(points))
    }

    const width: Object | undefined = data.get('width');
    if (width != undefined) {
      const wd = ConvertUtil.toFloatPixels(width)
      LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的宽度：${wd},${width}`)
      sink.setWidth(ConvertUtil.toFloatPixels(width))
    }

    const visible: Object | undefined = data.get('visible');
    if (visible != undefined) {
      const vs = ConvertUtil.toBoolean(visible)
      LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的可见：${vs}`)
      sink.setVisible(ConvertUtil.toBoolean(visible))
    }

    const geodesic: Object | undefined = data.get('geodesic');
    if (geodesic != undefined) {
      const geo = ConvertUtil.toBoolean(geodesic)
      LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的geo：${geo}`)
      sink.setGeodesic(ConvertUtil.toBoolean(geodesic))
    }

    const gradient: Object | undefined = data.get('gradient');
    if (gradient != undefined) {
      const gr = ConvertUtil.toBoolean(gradient)
      LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的gr：${gr}`)
      sink.setGradient(ConvertUtil.toBoolean(gradient))
    }

    const alpha: Object | undefined = data.get('alpha');
    if (alpha != undefined) {
      const gr = ConvertUtil.toFloat(alpha)
      LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的alpha：${gr}`)
      sink.setAlpha(ConvertUtil.toFloat(alpha))
    }

    const dashLineType: Object | undefined = data.get('dashLineType');
    if (dashLineType != undefined) {
      let rawType = ConvertUtil.toNumber(dashLineType)
      LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的dashLineType：${rawType}`)
      if (rawType > PolylineUtil.DASH_LINE_TYPE.length) {
        rawType = 0
      }
      if (PolylineUtil.DASH_LINE_TYPE[rawType] === -1) {
        sink.setDashLine(false)
      }else{
        sink.setDashLine(true)
        sink.setDashLineType(PolylineUtil.DASH_LINE_TYPE[rawType])
      }
    }

    const capType: Object | undefined = data.get('capType');
    LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的capType：${capType}`)
    if (capType != undefined) {
      sink.setLineCapType(ConvertUtil.toInt(capType))
    }

    const joinType: Object | undefined = data.get('joinType');
    LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的joinType：${joinType}`)
    if (joinType != undefined) {
      sink.setLineJoinType(ConvertUtil.toInt(joinType))
    }

    const customTexture: Object | undefined = data.get('customTexture');
    if (customTexture != undefined) {
      const bit = await ConvertUtil.toBitmapDescriptor(customTexture)
      LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的bit：${bit?.toString()}`)
      if (bit) {
        sink.setCustomTexture(bit)
      }

    }

    const customTextureList: Object | undefined = data.get('customTextureList');
    LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的customTextureList：${customTextureList?.toString()}`)
    if (customTextureList != undefined) {
      const bit = await ConvertUtil.toBitmapDescriptorList(customTextureList)
      if (bit) {
        sink.setCustomTextureList(bit)
      }
    }
    const color: Object | undefined = data.get('color');
    LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的color：${color}`)
    if (color != undefined) {
      sink.setColor(Constants.argbToHex(ConvertUtil.toNumber(color)))
    }

    const colorList: Object | undefined = data.get('colorList');
    if (colorList != undefined) {
      const list = ConvertUtil.toInt32List(colorList)
      LogUtil.i(PolylineUtil.CLASS_NAME,`获取到的colorList：${list.toString()}`)
      sink.setColorList(ConvertUtil.toInt32List(colorList))
    }

    const id: string = data.get('id') as string;
    if (id != undefined) {
      return id
    }
    return undefined
  }
}