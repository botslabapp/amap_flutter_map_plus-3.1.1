import { LatLng, LineJoinType, PolygonOptions } from "@amap/amap_lbs_map3d";
import { PolygonOptionsSink } from "./PolygonOptionsSink";
import { ArrayList } from "@kit.ArkTS";

export class PolygonOptionsBuilder implements PolygonOptionsSink {
  private options: PolygonOptions;


  constructor() {
    this.options = new PolygonOptions();
    this.options.setUsePolylineStroke(true)
  }

  setPoints(points: LatLng[]): void {
    let array = new ArrayList<LatLng>()
    points.forEach((lat)=>{
      array.add(lat)
    })
    this.options.setPoints(array);
  }

  setStrokeColor(color: number): void {
    this.options.setStrokeColor(color);
  }

  setFillColor(color: number): void {
    this.options.setFillColor(color);
  }

  setStrokeWidth(width: number): void {
    this.options.setStrokeWidth(width);
  }

  setZIndex(zIndex: number): void {
    this.options.setZIndex(zIndex)
  }

  setVisible(visible: boolean): void {
    this.options.setVisible(visible);
  }

  build(): PolygonOptions {
    return this.options;
  }
} 