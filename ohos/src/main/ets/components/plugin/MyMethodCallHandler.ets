import { MethodCall, MethodChannel, MethodResult } from "@ohos/flutter_ohos";

export interface MyMethodCallHandler {
  /**
   * 执行方法调用
   * @param call - 方法调用信息
   * @param result - 结果回调
   */
  doMethodCall(call: MethodCall, result: MethodResult): void;

  /**
   * 获取注册的方法ID数组
   * @return 返回注册的方法ID数组
   */
  getRegisterMethodIdArray(): string[];
}