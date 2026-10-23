package com.patch.nogate;

import android.graphics.Color;
import android.util.Log;

import java.util.HashSet;
import java.util.Set;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XC_MethodReplacement;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public class Main implements IXposedHookLoadPackage {
    private static final String TAG = "NoGateHook";
    private static final String TARGET = "com.dragon.read.oversea.gp";
    private static final String[] BG_NAMES = {
        "color_background_dark",
        "color_global_bg_black",
        "reader_black_theme_bg_v525",
        "reader_global_bg_black",
        "theme_background_black_v525"
    };
    private static final Set<Integer> BG_IDS = new HashSet<Integer>();
    private static volatile boolean resolved = false;

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) {
        if (lpparam == null || !TARGET.equals(lpparam.packageName)) {
            return;
        }
        Log.i(TAG, "loaded into " + lpparam.packageName);
        // block the illegal-access gate chain + its toast
        String[] assertClasses = {
            "com.dragon.read.component.base.NsBaseNetworkDependImpl",
            "com.dragon.read.base.depend.NsBaseNetworkDependImpl",
            "com.dragon.read.base.depend.NsBaseNetworkDependImpl$1"
        };
        for (String cls : assertClasses) {
            blockAll(cls, "assertIllegalAccess", lpparam.classLoader);
        }
        blockAll("com.dragon.read.util.ToastUtils", "showCommonToastSafely", lpparam.classLoader);
        // runtime night-bg pure-black override, ids resolved BY NAME (version-proof)
        try {
            Class<?> resCls = XposedHelpers.findClass("android.content.res.Resources", lpparam.classLoader);
            int n = XposedBridge.hookAllMethods(resCls, "getColor", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam param) {
                    Object res = param.thisObject;
                    if (!(res instanceof android.content.res.Resources)) {
                        return;
                    }
                    android.content.res.Resources r = (android.content.res.Resources) res;
                    if (!resolved) {
                        int found = 0;
                        for (String name : BG_NAMES) {
                            int id = 0;
                            try { id = r.getIdentifier(name, "color", TARGET); } catch (Throwable ignored) {}
                            if (id != 0) {
                                synchronized (BG_IDS) { BG_IDS.add(id); }
                                found++;
                            }
                            Log.i(TAG, "resolve " + name + " -> 0x" + Integer.toHexString(id));
                        }
                        if (found > 0) {
                            resolved = true;
                        }
                    }
                    Object a0 = param.args.length > 0 ? param.args[0] : null;
                    if (a0 instanceof Integer) {
                        int id = (Integer) a0;
                        synchronized (BG_IDS) {
                            if (BG_IDS.contains(id)) {
                                param.setResult(Color.BLACK);
                            }
                        }
                    }
                }
            }).size();
            Log.i(TAG, "color override installed count=" + n);
        } catch (Throwable t) {
            Log.i(TAG, "FAILED color hook: " + t);
        }
    }

    private static void blockAll(String className, String method, ClassLoader cl) {
        try {
            Class<?> c = XposedHelpers.findClass(className, cl);
            int n = XposedBridge.hookAllMethods(c, method, XC_MethodReplacement.DO_NOTHING).size();
            Log.i(TAG, "blocked " + className + "->" + method + " count=" + n);
        } catch (Throwable t) {
            Log.i(TAG, "FAILED block " + className + "->" + method + " : " + t);
        }
    }
}
