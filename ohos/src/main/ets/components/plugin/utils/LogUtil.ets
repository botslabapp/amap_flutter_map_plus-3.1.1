import hilog from '@ohos.hilog';

/**
 * LogUtil - 日志工具类
 */
export class LogUtil {
  private static readonly TAG = 'AMapMap';
  private static readonly DOMAIN = 0xFF00;
  public static isDebugMode: boolean = false; // 设置为true以便开发调试

  /**
   * 信息日志
   * @param className 类名
   * @param msg 日志信息
   */
  public static i(className: string, msg: string): void {
    if (LogUtil.isDebugMode) {
      hilog.info(LogUtil.DOMAIN, LogUtil.TAG, `[INFO] ${className}: ${msg}`);
    }
  }

  /**
   * 警告日志
   * @param className 类名
   * @param msg 日志信息
   */
  public static w(className: string, msg: string): void {
    if (LogUtil.isDebugMode) {
      hilog.warn(LogUtil.DOMAIN, LogUtil.TAG, `[WARN] ${className}: ${msg}`);
    }
  }

  /**
   * 错误日志
   * @param className 类名
   * @param method 方法名
   * @param error 错误信息
   */
  public static e(className: string, method: string, error?: Error): void {
    if (LogUtil.isDebugMode) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      const stack = error instanceof Error && error.stack ? `\nStack: ${error.stack}` : '';
      hilog.error(LogUtil.DOMAIN, LogUtil.TAG, `[ERROR] ${className}.${method}: ${errorMsg}${stack}`);
    }
  }
  
  /**
   * 调试日志
   * @param className 类名
   * @param msg 日志信息
   */
  public static d(className: string, msg: string): void {
    if (LogUtil.isDebugMode) {
      hilog.debug(LogUtil.DOMAIN, LogUtil.TAG, `[DEBUG] ${className}: ${msg}`);
    }
  }
  
  /**
   * 设置是否开启调试模式
   * @param enable 是否开启
   */
  public static setDebugMode(enable: boolean): void {
    LogUtil.isDebugMode = enable;
    hilog.info(LogUtil.DOMAIN, LogUtil.TAG, `[CONFIG] Debug mode ${enable ? 'enabled' : 'disabled'}`);
  }
} 