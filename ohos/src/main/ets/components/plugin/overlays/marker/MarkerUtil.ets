import { Any } from "@ohos/flutter_ohos";
import { ConvertUtil } from "../../utils/ConvertUtil";
import { MarkerOptionsSink } from "./MarkerOptionsSink";
import { ArrayList } from "@kit.ArkTS";

export class MarkerUtil {
  static async interpretMarkerOptions(obj: Object, sink: MarkerOptionsSink): Promise<string | undefined> {
    if (obj == undefined) {
      return undefined;
    }

    const data: Map<string | number, Any> = obj as Map<string | number, Any>;
    data.forEach((value:Any,key,aa:Map<string | number, Any>)=>{
      console.log(`MarkerUtil`,`${key}:${data.get(key)}`)
    })
    const alpha: Object | undefined = data.get('alpha');
    if (alpha != undefined) {
      sink.setAlpha(ConvertUtil.toNumber(alpha))
    }

    const anchor: Object | undefined = data.get('anchor');
    if (anchor != undefined) {
      const anchorData: object[] = ConvertUtil.toList(anchor)
      sink.setAnchor(ConvertUtil.toNumber(anchorData[0]), ConvertUtil.toNumber(anchorData[1]))
    }

    const consumeTapEvents: Object | undefined = data.get('consumeTapEvents');
    const draggable: object = data.get('draggable');
    if (draggable != undefined) {
      sink.setDraggable(ConvertUtil.toBoolean(draggable))
    }

    const flat: object = data.get('flat');
    if (flat != undefined) {
      sink.setFlat(ConvertUtil.toBoolean(flat))
    }

    const icon: object = data.get('icon');
    if (icon != undefined) {
      const a = await ConvertUtil.toBitmapDescriptor(icon);
      if (a != undefined) {
        console.log('MarkerUtil','icon有')
        sink.setIcon(a)
      }
    }

    const infoWindow: object = data.get('infoWindow');
    if (infoWindow != undefined) {
      MarkerUtil.interpretInfoWindowOptions(sink, infoWindow as Map<string, string>)
    }

    const position: object = data.get('position');
    if (position != undefined) {
      sink.setPosition(ConvertUtil.toLatLng(position))
    }

    const rotation: object = data.get('rotation');
    if (rotation != undefined) {
      sink.setRotation(Math.abs(360 - ConvertUtil.toNumber(rotation)))
    }

    const visible: object = data.get('visible');
    if (visible != undefined) {
      sink.setVisible(ConvertUtil.toBoolean(visible))
    }

    const zIndex: object = data.get('zIndex');
    if (zIndex != undefined) {
      sink.setZIndex(ConvertUtil.toNumber(zIndex))
    }

    const infoWindowEnable: object = data.get("infoWindowEnable");
    if (infoWindowEnable != undefined) {
      sink.setInfoWindowEnable(ConvertUtil.toBoolean(infoWindowEnable))
    }

    const clickable: object = data.get("clickable");
    if (clickable != undefined) {
      sink.setClickable(ConvertUtil.toBoolean(clickable))
    }

    const markerId: string = data.get("id");
    console.log(`MarkerUtil`,`${markerId}`);
    if (markerId != undefined) {
      return markerId;
    }

    return undefined
  }

  static interpretInfoWindowOptions(sink: MarkerOptionsSink, infoWindow: Map<string, string>) {
    let title: string = infoWindow.get('title') ?? ''
    let snippet: string = infoWindow.get('snippet') ?? ''
    if (title != undefined && title.length > 0) {
      sink.setTitle(title)
    }

    if (snippet != undefined && snippet.length > 0) {
      sink.setSnippet(snippet)
    }
  }
}