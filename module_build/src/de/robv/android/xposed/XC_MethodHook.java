package de.robv.android.xposed;
public abstract class XC_MethodHook {
  public static class MethodHookParam {
    public Object thisObject;
    public Object[] args;
    public Object result;
    public Throwable throwable;
    public void setResult(Object r) { this.result = r; }
  }
  protected void beforeHookedMethod(MethodHookParam param) throws Throwable {}
  protected void afterHookedMethod(MethodHookParam param) throws Throwable {}
}
