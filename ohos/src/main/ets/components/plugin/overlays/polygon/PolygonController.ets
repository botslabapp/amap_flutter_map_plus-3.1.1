import { LatLng, LineJoinType, Polygon } from "@amap/amap_lbs_map3d";
import { PolygonOptionsSink } from "./PolygonOptionsSink";
import { LogUtil } from "../../utils/LogUtil";
import { ArrayList } from "@kit.ArkTS";

export class PolygonController implements PolygonOptionsSink {
  private polygon: Polygon;
  private id:string;

  constructor(polygon: Polygon) {
    this.polygon = polygon;
    this.id = polygon.getId()
  }

  getId():string{
    return this.id
  }
  setPoints(points: LatLng[]): void {
    let array = new ArrayList<LatLng>()
    points.forEach((lat)=>{
      array.add(lat)
    })
    this.polygon.setPoints(array);
  }

  setStrokeColor(color: number): void {
    this.polygon.setStrokeColor(color);
  }

  setFillColor(color: number): void {
    this.polygon.setFillColor(color);
  }

  setStrokeWidth(width: number): void {
    this.polygon.setStrokeWidth(width);
  }

  setZIndex(zIndex: number): void {
    this.polygon.setZIndex(zIndex);
  }

  setVisible(visible: boolean): void {
    this.polygon.setVisible(visible);
  }


  remove(): void {
    try {
      this.polygon.remove();
    } catch (e) {
      LogUtil.e('PolygonController', `Error removing polygon: ${e}`);
    }
  }
} 