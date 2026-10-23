# 番茄小说 夜间纯黑显示修改（com.dragon.read.oversea.gp）

将番茄小说夜间阅读背景由 `#0E0E0E` 替换为 `#000000`，使 OLED 面板像素真正熄灭；并以 LSPosed 运行时模块处理该渠道包的"当前版本不安全"启动拦截。已在小米17（HyperOS 4 / Android 17）验证运行正常、夜间背景为纯黑，全程保数据安装。

![纯黑对比测试图](纯黑对比测试图.png)
（三段对比图：`#000000` / `#0E0E0E` / `#1A1A1A`，全屏打开即可肉眼判定面板黑位。）

## 根因：为什么夜间模式"不黑"

1. **App 输出的就不是纯黑。** 该版本夜间主题背景资源为 `#0E0E0E`（共 25 处，含 `reader_black_theme_bg_v525`、`reader_global_bg_black`、`theme_background_black_v525` 等），阅读设置中最深的背景色板同样是 `#0E0E0E`。OLED 面板只在输入 `#000000` 时熄灭像素，`#0E0E0E` 必然发光。
2. **同版本 App 在不同机型上的观感差异来自显示链路，而非 App。** 两台手机的夜间背景像素实测一致（背景 `#0E0E0E`、正文 `#B7B7B7`），肉眼差别源于屏幕调光与黑位处理（调光方式切换、防闪烁、色彩模式等）。
3. **因此要"真黑"，必须让 App 输出 `#000000`** —— 本项目通过替换资源颜色值 / 运行时改色实现。

## 修改原理

- `resources.arsc` 以 STORED 方式存放，颜色条目为标准 `Res_value`（头 `08 00 00 1c/1d` + ARGB 值），可精确字节替换；替换后同步修正 zip 的 CRC 字段。
- dex 中另有硬编码颜色常量（`const-wide`/`const` 系列指令）。**修改 dex 内容必须同步更新 dex 头部的 SHA-1（偏移 0x0C..0x1C）与 adler32（0x08..0x0C）**，否则运行时拒绝加载。
- 该渠道包带来源/版本校验：需在已获取 root 并配置好签名与安装来源伪装的设备上，通过 `pm install-create / install-write / install-commit` 以**同签名更新**方式保数据安装（签名密钥需保持不变，后续更新才不会丢数据）。

## 拦截页与纯黑：LSPosed 运行时模块

该渠道包带运行时保护（校验 dex 完整性，修改 dex 内容会被静默终止），因此拦截页与纯黑改色均采用**运行时 hook** 方案，不改动 APK：

- 模块源码：`module_build/`（包名 `com.patch.nogate`）
- 拦截页：hook `NsBaseNetworkDepend` 三个实现类的 `assertIllegalAccess` 为空操作（拦截 toast 一并屏蔽）
- 夜间纯黑：hook `Resources.getColor`，按**资源名**（`reader_black_theme_bg_v525` 等 5 项）运行时动态解析 ID 后返回纯黑——版本无关，应用更新后自动适配
- 启用：LSPosed 管理器 → 模块 → 启用 NoGate → 作用域勾选 `com.dragon.read.oversea.gp` → 强制停止并重开番茄小说
- 注意：每次更新模块 APK 后，需在 LSPosed 管理器中重新打开一次以刷新模块注册（安装路径变化）；新模块首次启用需重启手机

## 常见问题：自定义纯黑背景图为什么仍然发光

1. **夜间阅读页的背景是分层合成的**：最底层是主题背景色（`#0E0E0E`），自定义背景图/纹理按透明度混合在其上；夜间模式的最终画面由主题层决定。实测启用自定义背景后，夜间页面输出仍为精确的 `#0E0E0E`（与主题资源值一致），自定义图并未参与夜间画面。
2. **即使参与合成也无法得到纯黑**：混合公式为 `输出 = α × 图 + (1-α) × 主题色`，只要主题色 > 0，结果永远大于 0，OLED 像素必然发光。
3. 相册中"看起来纯黑"的图片像素未必是 `#000000`（截图/压缩常带微小噪点），但这只是次要因素。
4. 本方案直接将主题色输出改为 `#000000`，合成结果必为 0，像素熄灭。
5. **验证方法**：修改前的版本在日间模式下应用同一张纯黑自定义背景——日间纯黑、夜间发灰，即可证明夜间模式覆盖自定义背景。

## 项目结构

```
├── README.md
├── 纯黑对比测试图.png          # 黑位对比测试图（预览/验证用）
├── patch_arsc_only.py         # 仅替换 arsc 颜色（推荐，改动最小）
├── patch_full.py              # arsc + dex 全量颜色替换
├── patch_v70932.py            # 7.0.9.32 版本全量颜色替换
├── find_sig.py                # APK 内签名指纹/常量检索工具
├── fix_onsite.sh              # 设备端字节级修复脚本模板（dd 就地补丁）
├── fix_min.sh                 # 最小修改配方脚本
├── fix_gate.sh / fix_gate2.sh / fix_restore.sh
├── remote_install.ps1         # 远程设备分块传输安装
├── http_install.ps1           # 远程设备 HTTP 传输安装
├── color_offsets.json         # 7.0.9.32 颜色资源名与文件偏移清单
└── module_build/              # LSPosed 模块（NoGate）源码与打包脚本
    ├── AndroidManifest.xml
    ├── assemble.py            # 组装 APK（注入 classes.dex 与 assets/xposed_init）
    ├── assets/xposed_init
    └── src/                   # Main.java 与编译期 Xposed API 桩
```

## 依赖与运行环境

- **构建**：JDK 21（javac/jar）、Android build-tools（d8、aapt2、apksigner）、Python 3、adb
- **运行**：已 root 的 Android 设备 + LSPosed（模块）；保数据安装需签名与安装来源伪装能力（如 CorePatch 类工具）
- **网络**：脚本本身不需要联网；App 的云端内容加载依赖其自身服务

## 构建与安装

```bash
# 1) 打颜色补丁（示例：仅资源）
python patch_arsc_only.py m17_base.apk m17_base_patched.apk

# 2) 对齐 + 重签名（用你自己的密钥库；后续更新必须沿用同一密钥）
zipalign -f -p 4 m17_base_patched.apk m17_base_aligned.apk
apksigner sign --ks your.keystore --ks-pass pass:<password> --ks-key-alias <alias> \
  --key-pass pass:<password> --out m17_base_black_signed.apk m17_base_aligned.apk

# 3) 保数据安装（base + 原 split 全部提供）
adb install-multiple -r m17_base_black_signed.apk split_config.*.apk
# 远程设备：使用 remote_install.ps1（分块传输）或 http_install.ps1，或 fix_onsite.sh 就地字节修复

# LSPosed 模块构建
cd module_build
javac -source 8 -target 8 -cp android.jar -d classes $(find src -name '*.java')
jar --create --file /tmp/mod.jar -C classes com
java -cp <build-tools>/lib/d8.jar com.android.tools.r8.D8 --output /tmp /tmp/mod.jar
python assemble.py base_unsigned.apk /tmp/classes.dex assets/xposed_init nogate_unsigned.apk
apksigner sign --ks your.keystore --out nogate_module.apk nogate_unsigned.apk
```

## 验证

1. 打开番茄小说 → 任意书 → 夜间模式，截图取样背景 RGB 应为 `#000000`；
2. 或全屏打开 `纯黑对比测试图.png`：左侧 `#000000` 区域应完全不发光（对比中、右两段）；
3. 冷启动不应再出现"当前版本不安全，请到正规应用市场下载"拦截页（配合 LSPosed 模块）。

## 声明

- 本项目仅用于个人技术研究与学习，与字节跳动、番茄小说及其关联方**无任何官方关联**，亦不代表其立场。
- 仓库**不包含**签名密钥（`*.jks`）与任何原始 APK；请使用你自己生成的密钥、你自己设备提取的原包。
- 仓库内容按"原样"提供，未附加开源许可证：可自由阅读，但**未授予**复制、修改或再分发的明确权利。
