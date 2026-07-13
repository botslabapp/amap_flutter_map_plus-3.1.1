import { LatLng, BitmapDescriptor, LineCapType, LineJoinType, Polyline } from "@amap/amap_lbs_map3d";
import { PolylineOptionsSink } from "./PolylineOptionsSink";
import { ArrayList } from "@kit.ArkTS";
import { Constants } from "../../utils/Constants";

export class PolylineController implements PolylineOptionsSink{
  private _polyline:Polyline
  private _polylineId:string
  constructor(polyline:Polyline) {
    this._polyline = polyline
    this._polylineId = polyline.getId()
  }
  public getPolylineId():string{
    return this._polylineId
  }
  public remove(){
    this._polyline.remove()
  }
  setPoints(points:ArrayList<LatLng>): void {
    this._polyline.setPoints(points)
  }

  setWidth(width: number): void {
    this._polyline.setWidth(width)
  }

  setColor(color: number): void {
    this._polyline.setColor(Constants.argbToHex(color))
  }

  setVisible(visible: boolean): void {
    this._polyline.setVisible(visible)
  }

  setCustomTexture(customTexture: BitmapDescriptor): void {
    const options = this._polyline.getOptions()
    options.setCustomTexture(customTexture)
    this._polyline.setOptions(options)
  }

  setCustomTextureList(customTextureList:ArrayList<BitmapDescriptor>): void {
    const options = this._polyline.getOptions()
    options.setCustomTextureList(customTextureList)
    this._polyline.setOptions(options)
  }

  setColorList(colorList:Int32Array): void {
    const options = this._polyline.getOptions()
    options.setColorValues(colorList)
    this._polyline.setOptions(options)
  }

  setCustomIndexList(customIndexList: Int32Array): void {
    const options = this._polyline.getOptions()
    options.setCustomTextureIndex(customIndexList)
    this._polyline.setOptions(options)
  }

  setGeodesic(geodesic: boolean): void {
    this._polyline.setGeodesic(geodesic)
  }

  setGradient(gradient: boolean): void {
    const options = this._polyline.getOptions()
    options.setGradient(gradient)
    this._polyline.setOptions(options)
  }

  setAlpha(alpha: number): void {
    this._polyline.setTransparency(alpha)
  }

  setDashLineType(type: number): void {
    const options = this._polyline.getOptions()
    options.setDottedLineType(type + 1)
    this._polyline.setOptions(options)
  }

  setDashLine(dashLine: boolean): void {
    this._polyline.setDottedLine(dashLine)
  }

  setLineCapType(lineCapType: LineCapType): void {
    const options = this._polyline.getOptions()
    options.setLineCapType(lineCapType)
    this._polyline.setOptions(options)
  }

  setLineJoinType(joinType: LineJoinType): void {
    const options = this._polyline.getOptions()
    options.setLineJoinType(joinType)
    this._polyline.setOptions(options)
  }

}