import { LatLng } from "@amap/amap_lbs_map3d";

export interface PolygonOptionsSink {
  setPoints(points: LatLng[]): void;
  setStrokeColor(color: number): void;
  setFillColor(color: number): void;
  setStrokeWidth(width: number): void;
  setZIndex(zIndex: number): void;
  setVisible(visible: boolean): void;
} 