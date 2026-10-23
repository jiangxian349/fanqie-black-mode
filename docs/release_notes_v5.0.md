NoGate 模块 v5：番茄小说（com.dragon.read.oversea.gp）夜间纯黑 + 启动拦截处理。

## 功能
- 夜间纯黑：hook Resources.getColor，按资源名（reader_black_theme_bg_v525 等 5 项）运行时动态解析 ID 返回 #000000 —— 版本无关，App 更新后自动适配
- 拦截屏蔽：hook NsBaseNetworkDepend 三个实现类的 assertIllegalAccess 为空操作（含拦截 toast）
- 不修改 APK 本体（该渠道包带运行时 dex 校验，改包会被静默终止）

## 要求
- 已 root 的 Android 设备 + LSPosed
- 启用：LSPosed 管理器 → 模块 → 启用 NoGate → 作用域勾选 com.dragon.read.oversea.gp → 强制停止并重开番茄小说
- 首次启用模块需重启手机；每次更新模块后需在 LSPosed 管理器重新打开一次以刷新注册

## 贡献者
- @jiangxian349
- claude（Claude Code）

## 说明
- 本仓库不提供番茄小说修改版本体（版权原因）；请使用你自己设备提取的原包与本模块配合
- 模块源码见仓库 module_build/，MIT 许可证
