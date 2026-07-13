import { BitmapDescriptor, LatLng, LineCapType, LineJoinType, PolylineOptions } from '@amap/amap_lbs_map3d';
import { ArrayList } from '@kit.ArkTS';

export interface PolylineOptionsSink {
  setPoints(points:ArrayList<LatLng>):void;
  setWidth(width:number):void;
  setColor(color:number):void;
  setVisible(visible:boolean):void;
  setCustomTexture(customTexture:BitmapDescriptor):void;
  setCustomTextureList(customTextureList:ArrayList<BitmapDescriptor>):void;
  setColorList(colorList:Int32Array):void;
  setCustomIndexList(customIndexList:Int32Array):void;
  setGeodesic(geodesic:boolean):void;
  setGradient(gradient:boolean):void;
  setAlpha(alpha: number): void;
  setDashLineType(type:number):void;
  setDashLine(dashLine:boolean):void;
  setLineCapType(lineCapType:LineCapType):void;
  setLineJoinType(joinType:LineJoinType):void;
}

