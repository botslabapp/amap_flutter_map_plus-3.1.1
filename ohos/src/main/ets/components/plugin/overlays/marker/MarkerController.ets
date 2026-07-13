import { BitmapDescriptor, LatLng, Marker } from "@amap/amap_lbs_map3d";
import { MarkerOptionsSink } from "./MarkerOptionsSink";

export class MarkerController implements MarkerOptionsSink {
  private _marker?: Marker;
  private _markerId?: string;

  constructor(marker?: Marker) {
    this._marker = marker;
    this._markerId = marker?.getId();
  }

  public getMarkerId(): string | undefined {
    return this._markerId;
  }
  public getMarker():Marker{
    return this._marker!
  }

  public remove() {
    if (this._marker != undefined) {
      this._marker.remove();
    }
  }

  public getPosition(): LatLng | undefined {
    if (this._marker != undefined) {
      return this._marker.getPosition();
    }
    return undefined;
  }

  setAlpha(alpha: number): void {
    this._marker?.setAlpha(alpha)
  }

  setAnchor(u: number, v: number): void {
    this._marker?.setAnchor(u, v)
  }

  setDraggable(draggable: boolean): void {
    this._marker?.setDraggable(draggable)
  }

  setFlat(flat: boolean): void {
    this._marker?.setFlat(flat)
  }

  setIcon(bitmapDescriptor: BitmapDescriptor): void {
    this._marker?.setIcon(bitmapDescriptor)
  }

  setTitle(title: string): void {
    this._marker?.setTitle(title)
  }

  setSnippet(snippet: string): void {
    this._marker?.setSnippet(snippet)
  }

  setPosition(position: LatLng): void {
    this._marker?.setPosition(position)
  }

  setRotation(rotation: number): void {
    this._marker?.setRotateAngle(rotation)
  }

  setVisible(visible: boolean): void {
    this._marker?.setVisible(visible);
  }

  setZIndex(zIndex: number): void {
    this._marker?.setZIndex(zIndex);
  }

  setInfoWindowEnable(enable: boolean): void {
    this._marker?.setInfoWindowEnable(enable);
  }

  setClickable(clickable: boolean): void {
    this._marker?.setClickable(clickable);
  }

  public showInfoWindow() {
    this._marker?.showInfoWindow();
  }

  public hideInfoWindow() {
    this._marker?.hideInfoWindow();
  }
}