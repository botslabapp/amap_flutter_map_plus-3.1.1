import { BitmapDescriptor, LatLng } from '@amap/amap_lbs_map3d';

export interface MarkerOptionsSink {
  setAlpha(alpha: number): void;
  setAnchor(u: number, v: number): void;
  setDraggable(draggable: boolean): void;
  setFlat(flat: boolean): void;
  setIcon(bitmapDescriptor: BitmapDescriptor): void;
  setTitle(title: string): void;
  setSnippet(snippet: string): void;
  setPosition(position: LatLng): void;
  setRotation(rotation: number): void;
  setVisible(visible: boolean): void;
  setZIndex(zIndex: number): void;
  setInfoWindowEnable(enable: boolean): void;
  setClickable(clickable: boolean): void;
}

