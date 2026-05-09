# luci-app-mentohust

[MentoHUST](https://code.google.com/archive/p/mentohust/) 是一个支持锐捷认证的客户端程序，常用于校园网认证场景。本仓库包含 `mentohust` OpenWrt 客户端和对应的 LuCI 管理界面。

这个 fork 主要修复旧版 OpenWrt / nradio AppCenter 环境中 `luci-app-mentohust` 打开后空白、无法渲染的问题。

## 修复内容

- 将 LuCI 管理页从新版 JS view/menu 入口改为兼容性更好的传统 Lua controller + CBI 页面。
- 修复 nradio AppCenter 只能看到包、但无法打开 LuCI 页面的问题。
- 安装 `luci-app-mentohust` 时自动创建缺失的 `/etc/config/mentohust`。
- 安装时自动向 `/etc/config/appcenter` 注册 `luci-app-mentohust` 的 LuCI 路由：

  ```text
  admin/services/mentohust
  ```

- 安装时自动写入 AppCenter 用于发现页面的 controller 文件：

  ```text
  /usr/lib/lua/luci/controller/mentohust.lua
  ```

- 安装后自动清理 LuCI 缓存，并重启 `rpcd` 和 `appcenter`，避免升级后仍然打开旧缓存。
- 增加 Docker SDK 构建脚本，方便只重打 LuCI IPK。

## 适用场景

这个版本主要面向比较老的 OpenWrt / LuCI 环境，尤其是 AppCenter 依赖 Lua controller 扫描入口的固件。

已在以下环境验证：

```text
OpenWrt 21.02-SNAPSHOT
nradio 2.1.0.n0.c1
target: mediatek/mt7987
arch: aarch64_cortex-a53
```

验证结果：

- AppCenter 能生成 `/tmp/appcenter/luci/admin.services.mentohust`
- `ubus call appcenter list` 能输出 `luci_module_route: admin/services/mentohust`
- `/cgi-bin/luci/admin/services/mentohust` 返回完整 CBI 表单，不再是空白页

## 构建 LuCI IPK

只构建 LuCI 包可以直接使用仓库内的 Docker SDK 脚本：

```sh
./scripts/build-luci-ipk-docker.sh
```

默认使用：

```text
openwrt/sdk:x86_64-21.02.7
```

输出目录默认为：

```text
../openwrt-sdk-work/build
```

构建完成后会得到类似：

```text
luci-app-mentohust_1.0.3_all.ipk
luci-i18n-mentohust-zh-cn_*.ipk
```

`luci-app-mentohust` 是 `Architecture: all`，只包含 LuCI 页面和配置脚本，不包含 `mentohust` 二进制本体。

## 构建完整 OpenWrt 包

如果需要同时编译 `mentohust` 二进制，需要使用与你设备 target 匹配的 OpenWrt SDK 或完整 buildroot，因为 `mentohust` 本体依赖目标架构交叉编译。

在 OpenWrt 源码目录中：

```sh
git clone https://github.com/uaih3k9x/luci-app-mentohust package/mentohust
make menuconfig
make V=s
```

在 `menuconfig` 中选择：

```text
LuCI -> Applications -> luci-app-mentohust
Network -> Ruijie -> mentohust
```

## 安装

将构建出的 IPK 上传到路由器后安装：

```sh
opkg install --force-reinstall /tmp/luci-app-mentohust_1.0.3_all.ipk
opkg install --force-reinstall /tmp/luci-i18n-mentohust-zh-cn_*.ipk
```

如果你的固件缺少 `mentohust` 二进制本体，还需要安装对应架构的 `mentohust_*.ipk`。

安装完成后，可以检查 AppCenter 是否已经识别：

```sh
ubus call appcenter list | grep -A20 luci-app-mentohust
find /tmp/appcenter/luci -maxdepth 1 -type f | grep mentohust
```

正常情况下应能看到：

```text
admin/services/mentohust
/tmp/appcenter/luci/admin.services.mentohust
```

## 页面入口

LuCI 直接入口：

```text
/cgi-bin/luci/admin/services/mentohust
```

在 nradio 固件上，也可以进入：

```text
更多 -> 应用商店 -> MentoHUST
```

![LuCI MentoHUST](https://user-images.githubusercontent.com/16485166/219599380-2a433cf3-e035-414d-a402-bea587d3a755.png)
