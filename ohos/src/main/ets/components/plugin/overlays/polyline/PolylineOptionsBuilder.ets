import { LatLng, BitmapDescriptor, LineCapType, LineJoinType, PolylineOptions } from '@amap/amap_lbs_map3d';
import { PolylineOptionsSink } from './PolylineOptionsSink';
import ArrayList from '@ohos.util.ArrayList';
import { LogUtil } from '../../utils/LogUtil';
import { Constants } from '../../utils/Constants';

export class PolylineOptionsBuilder implements PolylineOptionsSink{
  private polylineOptions:PolylineOptions
  constructor() {
    this.polylineOptions = new PolylineOptions()
  }
  setPoints(points: ArrayList<LatLng>): void {
    this.polylineOptions.setPoints(points)
  }

  setWidth(width: number): void {
    this.polylineOptions.setWidth(width)
  }



  setColor(color: number): void {
    LogUtil.i('PolylineOptionsBuilder',`color is : ${Constants.argbToHex(color).toString()},${Constants.argbToHex(color)}`)
    this.polylineOptions.setColor(Constants.argbToHex(color))
  }

  setVisible(visible: boolean): void {
    this.polylineOptions.setVisible(visible)
  }

  setCustomTexture(customTexture: BitmapDescriptor): void {
    this.polylineOptions.setCustomTexture(customTexture)
  }

  setCustomTextureList(customTextureList: ArrayList<BitmapDescriptor>): void {
    this.polylineOptions.setCustomTextureList(customTextureList)
  }

  setColorList(colorList: Int32Array): void {
    this.polylineOptions.setColorValues(colorList)
  }

  setCustomIndexList(customIndexList: Int32Array): void {
    this.polylineOptions.setCustomTextureIndex(customIndexList)
  }

  setGeodesic(geodesic: boolean): void {
    this.polylineOptions.setGeodesic(geodesic)
  }

  setGradient(gradient: boolean): void {
    this.polylineOptions.setGradient(gradient)
  }

  setAlpha(alpha: number): void {
    this.polylineOptions.setTransparency(alpha)
  }

  setDashLineType(type: number): void {
    this.polylineOptions.setDottedLineType(type)
  }

  setDashLine(dashLine: boolean): void {
    this.polylineOptions.setDottedLine(dashLine)
  }

  setLineCapType(lineCapType: LineCapType): void {
    this.polylineOptions.setLineCapType(lineCapType)
  }

  setLineJoinType(joinType: LineJoinType): void {
    this.polylineOptions.setLineJoinType(joinType)
  }
  public build(){
    return this.polylineOptions
  }
}