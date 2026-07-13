import { Any, ToolUtils } from '@ohos/flutter_ohos';

export class CommonUtils {

  static argumentParse(key: string, args: Any): Any {
    if (args == null) {
      return null;
    } else if (args instanceof Map) {
      return (args as Map<Any, Any>).get(key);
    } else if (ToolUtils.isObj(args)) {
      return args[key]
    } else {
      throw new Error("ClassCastException");
    }
  }
}