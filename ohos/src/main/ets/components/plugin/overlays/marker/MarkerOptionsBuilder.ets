import { BitmapDescriptor, LatLng, MarkerOptions } from '@amap/amap_lbs_map3d';
import { MarkerOptionsSink } from './MarkerOptionsSink';

export class MarkerOptionsBuilder implements MarkerOptionsSink {
  private markerOptions: MarkerOptions;

  constructor() {
    this.markerOptions = new MarkerOptions();
  }

  build(): MarkerOptions {
    return this.markerOptions;
  }

  setAlpha(alpha: number): void {
    this.markerOptions.setAlpha(alpha)
  }

  setAnchor(u: number, v: number): void {
    this.markerOptions.setAnchor(u, v)
  }

  setDraggable(draggable: boolean): void {
    this.markerOptions.setDraggable(draggable)
  }

  setFlat(flat: boolean): void {
    this.markerOptions.setFlat(flat)
  }

  setIcon(bitmapDescriptor: BitmapDescriptor): void {
    this.markerOptions.setIcon(bitmapDescriptor)
  }

  setTitle(title: string): void {
    this.markerOptions.setTitle(title)
  }

  setSnippet(snippet: string): void {
    this.markerOptions.setSnippet(snippet)
  }

  setPosition(position: LatLng): void {
    this.markerOptions.setPosition(position)
  }

  setRotation(rotation: number): void {
    this.markerOptions.setRotateAngle(rotation)
  }

  setVisible(visible: boolean): void {
    this.markerOptions.setVisible(visible)
  }

  setZIndex(zIndex: number): void {
    this.markerOptions.setZIndex(zIndex)
  }

  setInfoWindowEnable(enable: boolean): void {
    this.markerOptions.setInfoWindowEnable(enable)
  }

  setClickable(clickable: boolean): void {
    this.markerOptions.setClickable(clickable)
  }
}
