<div align="center">
  <h1>Mole</h1>
  <p><em>🐹 在终端中清理、卸载、分析、优化和监控你的 Mac。</em></p>
</div>

<p align="center">
  <a href="https://github.com/XiaoWoUi/Mole-CN/stargazers"><img src="https://img.shields.io/github/stars/XiaoWoUi/Mole-CN?style=flat-square" alt="Stars"></a>
  <a href="https://github.com/XiaoWoUi/Mole-CN/releases"><img src="https://img.shields.io/github/v/tag/XiaoWoUi/Mole-CN?label=version&style=flat-square" alt="Version"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL_v3-blue.svg?style=flat-square" alt="License"></a>
  <a href="https://github.com/XiaoWoUi/Mole-CN/commits"><img src="https://img.shields.io/github/commit-activity/m/XiaoWoUi/Mole-CN?style=flat-square" alt="Commits"></a>
  <a href="https://twitter.com/HiTw93"><img src="https://img.shields.io/badge/follow-Tw93-red?style=flat-square&logo=Twitter" alt="Twitter"></a>
  <a href="https://t.me/+9f9gf4ZrFSQ2OWVl"><img src="https://img.shields.io/badge/chat-Telegram-blueviolet?style=flat-square&logo=Telegram" alt="Telegram"></a>
</p>

<p align="center">
  <img src="https://gw.alipayobjects.com/zos/k/ro/ZzF8e8.png" alt="Mole - 释放 95.50GB" width="1000" />
</p>

> 💡 CLI 免费且开源。更喜欢原生 Mac 应用?[Mole for Mac](https://mole.fit) 提供了可视化清理预览、应用更新、卸载、维护、磁盘图谱、实时状态和菜单栏 HUD。一份授权可覆盖 2 台 Mac,终身更新,支持 14 天退款。

## 功能特性

- **一体化工具包**:将 CleanMyMac、AppCleaner、DaisyDisk 和 iStat Menus 集成为**一个二进制文件**
- **深度清理**:移除缓存、日志、残留文件和孤立的应用数据,**释放数 GB 空间**
- **智能卸载**:移除应用及其启动代理、偏好设置和**隐藏残留**
- **磁盘洞察**:可视化占用情况、查找大文件、**重建缓存**并刷新系统服务
- **实时监控**:显示实时的 CPU、GPU、内存、磁盘和网络状态

## 快速开始

> 简体中文版(Mole-CN)暂不提供 Homebrew 安装方式,请使用以下脚本安装。

### 方式一:一键安装(推荐)

在终端中直接运行:

```bash
curl -fsSL https://raw.githubusercontent.com/XiaoWoUi/Mole-CN/main/install.sh | bash
```

脚本会自动完成:下载源码 → 构建或获取二进制 → 安装到 `/usr/local/bin` → 验证安装。

> 安装过程中如提示输入密码,请输入你的 Mac 管理员密码(脚本需要权限写入 `/usr/local/bin`)。

可选参数:

```bash
# 安装 main 分支最新代码(夜间版)
curl -fsSL https://raw.githubusercontent.com/XiaoWoUi/Mole-CN/main/install.sh | bash -s latest

# 安装指定版本(例如 V1.17.0)
curl -fsSL https://raw.githubusercontent.com/XiaoWoUi/Mole-CN/main/install.sh | bash -s 1.17.0
```

### 方式二:下载到本地后运行

如果不习惯 `curl | bash` 直接执行,可以先下载到本地、查看内容,再运行:

```bash
# 1. 下载安装脚本到当前目录
curl -fsSL https://raw.githubusercontent.com/XiaoWoUi/Mole-CN/main/install.sh -o install.sh

# 2. (可选)先查看脚本内容,确认无误
less install.sh

# 3. 运行安装
bash install.sh
```

同样支持参数:

```bash
bash install.sh latest        # 安装 main 分支最新代码(夜间版)
bash install.sh 1.17.0        # 安装指定版本
bash install.sh --prefix ~/bin   # 安装到自定义目录
```

### 安装完成后

**1. 验证安装**

```bash
mo --version
```

看到 `Mole 版本 1.50.0` 即安装成功。

**2. 如果提示 `mo: command not found`**

说明 `/usr/local/bin` 不在 PATH 中,把下面这行加到 `~/.zshrc`(或 `~/.bash_profile`),然后重新打开终端:

```bash
export PATH="/usr/local/bin:$PATH"
```

**3. 开始使用**

```bash
mo                    # 交互式主菜单
mo clean --dry-run    # 预演清理(推荐先试这个,不会删除任何文件)
mo clean              # 深度清理缓存、日志、残留
mo status             # 实时系统健康仪表盘
mo analyze            # 磁盘空间分析
mo --help             # 查看全部命令
```

**4. 更新与卸载**

```bash
mo update             # 更新到最新版本
mo remove             # 从系统中移除 Mole
```

> 注意:Mole 面向 macOS 构建。实验性 Windows 版本可在 [windows 分支](https://github.com/tw93/Mole/tree/windows) 中获取,供早期体验者使用。

**运行**

```bash
mo                           # 交互式菜单
mo clean                     # 深度清理 + 已卸载应用的残留
mo uninstall                 # 移除已安装应用及其残留
mo optimize                  # 刷新缓存与服务
mo analyze                   # 可视化磁盘浏览器(或 'mo analyse')
mo status                    # 实时系统健康仪表盘
mo purge                     # 清理项目构建产物
mo installer                 # 查找并移除安装包文件

mo touchid                   # 为 sudo 配置 Touch ID
mo completion                # 设置 shell 补全
mo update                    # 更新 Mole
mo update --nightly          # 更新到最新未发布的 main 构建(仅脚本安装)
mo remove                    # 从系统中移除 Mole
mo --help                    # 显示帮助
mo --version                 # 显示已安装版本
```

**安全预览**

```bash
mo clean --dry-run
mo uninstall --dry-run
mo history
mo history --json
mo purge --dry-run

# 也适用于: optimize、installer、remove、completion、touchid enable
mo clean --dry-run --debug   # 预演 + 详细日志
mo optimize --whitelist      # 管理受保护的优化规则
mo clean --whitelist         # 管理受保护的缓存
mo purge --paths             # 配置项目扫描目录
mo analyze /Volumes          # 仅分析外置磁盘
mo analyze /private/tmp      # 查看用户拥有的临时目录
```

`mo clean --whitelist` 做出的选择会持久保存在 `~/.config/mole/whitelist`。

## 安全与安全设计

Mole 是一款本地系统维护工具,部分命令可能执行具有破坏性的本地操作。

Mole 采用安全优先的默认策略:路径校验、受保护目录规则、保守的清理边界,以及对高风险操作进行明确确认。当风险或不确定性较高时,Mole 会选择跳过、拒绝或要求更强的确认,而不是扩大删除范围。

`mo analyze` 更适合临时清理,因为它通过 Finder 将文件移入废纸篓,而不是直接删除。

请查阅 [SECURITY.md](SECURITY.md) 和 [SECURITY_AUDIT.md](SECURITY_AUDIT.md) 了解报告指引、安全边界和当前限制。

## 小贴士

- 视频教程:观看 [Mole 教程视频](https://www.youtube.com/watch?v=UEe9-w4CcQ0),感谢 PAPAYA 電腦教室。
- 安全与日志:`clean`、`uninstall`、`purge`、`installer` 和 `remove` 具有破坏性。请先用 `--dry-run` 预览,必要时加上 `--debug`。文件操作会记录到 `~/Library/Logs/mole/operations.log`,可用 `mo history` 查看。通过 `MO_NO_OPLOG=1` 禁用。请查阅 [SECURITY.md](SECURITY.md) 和 [SECURITY_AUDIT.md](SECURITY_AUDIT.md)。
- 应用残留:应用已卸载时使用 `mo clean`,应用仍在安装时使用 `mo uninstall`。
- 导航:Mole 支持方向键和 Vim 按键 `h/j/k/l`。

## 功能详解

### 深度系统清理

```bash
$ mo clean

正在扫描缓存目录...

  ✓ 用户应用缓存                                           45.2GB
  ✓ 浏览器缓存 (Chrome、Safari、Firefox)                    10.5GB
  ✓ 开发者工具 (Xcode、Node.js、npm)                        23.3GB
  ✓ 系统日志与临时文件                                        3.8GB
  ✓ 应用专属缓存 (Spotify、Dropbox、Slack)                   8.4GB
  ✓ 废纸篓                                                   12.3GB

====================================================================
释放空间: 95.5GB | 当前可用空间: 223.5GB
====================================================================
```

注意:在 `mo clean` → 开发者工具中,Mole 会移除未使用的 CoreSimulator `Volumes/Cryptex` 条目,并跳过 `IN_USE` 项目。

### 智能应用卸载

```bash
$ mo uninstall

选择要移除的应用
═══════════════════════════
▶ ☑ Photoshop 2024            (4.2G) | 较早
  ☐ IntelliJ IDEA             (2.8G) | 最近
  ☐ Premiere Pro              (3.4G) | 最近

正在卸载: Photoshop 2024

  ✓ 已移除应用
  ✓ 已清理 12 个位置的 52 个相关文件
    - 应用程序支持、缓存、偏好设置
    - 日志、WebKit 存储、Cookie
    - 扩展、插件、启动守护进程

====================================================================
释放空间: 12.8GB
====================================================================
```

### 系统优化

```bash
$ mo optimize

系统: 5/32 GB 内存 | 333/460 GB 磁盘 (72%) | 已运行 6d

  ✓ 检查并修复支持的系统维护项目
  ✓ 刷新符合条件的 Finder、网络和数据库状态
  ✓ 跳过不必要、当前不安全或不可用的任务

====================================================================
优化完成
====================================================================
已应用 8 项优化
9 项未变化 | 4 项已跳过 | 2 项不可用
优化流程已完成
```

使用 `mo optimize --whitelist` 排除特定优化。路径模式同样适用,因此你可以长期挂载磁盘映像(例如 `/Volumes/mail`)而不让它显示为可卸载候选。

优化结果取决于 Mac 的当前状态和可用的系统工具,因此上述数量仅作示例,并非固定值。

### 磁盘空间分析器

> 注意:默认情况下,Mole 会跳过 `/Volumes` 下的外置磁盘以加快启动速度。如需检查,请运行 `mo analyze /Volumes` 或指定挂载路径。

开发者工具可能会在 `/private/tmp` 下留下大型临时目录。使用 `mo analyze /private/tmp` 查看用户拥有的条目;选中的条目仅在确认后移入废纸篓。Mole 不会自动删除第三方临时目录,因为仅凭构建标记和文件年龄无法证明某个检出或工作树可以丢弃。

```bash
$ mo analyze

磁盘分析  (剩余 302.1GB)
选择一个位置进行探索:

 ▶  1. ████████████████████████  47.9%  |  个人目录                   75.4GB
    2. ███████████               22.0%  |  用户资源库                 34.6GB
    3. ███████                   14.2%  |  应用程序                   22.4GB
    4. █████                     10.7%  |  系统资源库                 16.9GB
    5. ███                        5.2%  |  旧下载文件(90 天以上)      8.2GB  >3月

↑↓→ | 回车 | R 刷新 | O 打开 | P 预览 | F 文件 | Esc/Q 退出
```

### 实时系统状态

包含健康评分、硬件信息和性能指标的实时仪表盘。

```bash
$ mo status

状态  健康 ● 92  MacBook Pro · M4 Pro · 32GB · macOS 14.5

⚙ CPU                                    ▦ 内存
总计   ████████████░░░░░░░  45.2%       已用    ███████████░░░░░░░  58.4%
负载   0.82 / 1.05 / 1.23 (8 核)        总计    14.2 / 24.0 GB
核心 1 ███████████████░░░░  78.3%       空闲    ████████░░░░░░░░░░  41.6%
核心 2 ████████████░░░░░░░  62.1%       可用    9.8 GB

▤ 磁盘                                   ⚡ 电源
已用   █████████████░░░░░░  67.2%       电量    ██████████████████  100%
空闲   156.3 GB                          状态    已充满
读     ▮▯▯▯▯  2.1 MB/s                  健康    正常 · 423 次循环
写     ▮▮▮▯▯  18.3 MB/s                 温度    58°C · 1200 RPM

⇅ 网络                                  ▶ 进程
下行   ▁▁█▂▁▁▁▁▁▁▁▁▇▆▅▂  0.54 MB/s      Code       ▮▮▮▮▯  42.1%
上行   ▄▄▄▃▃▃▄▆▆▇█▁▁▁▁▁  0.02 MB/s      Chrome     ▮▮▮▯▯  28.3%
代理   HTTP · 192.168.1.100             Terminal   ▮▯▯▯▯  12.5%
```

健康评分基于 CPU、内存、磁盘、温度和 I/O 负载,带有分级配色。

快捷键:在 `mo status` 中,按 `k` 切换小猫显示,按 `c` 循环切换卡片列出的 CPU 核心数量(2、4、8、全部),按 `q` 退出。两个偏好都会保存。

启用后,`mo status` 会为持续超过设定 CPU 阈值的进程显示只读告警横幅。使用 `--proc-cpu-threshold`、`--proc-cpu-window` 或 `--proc-cpu-alerts=false` 进行调整或关闭。

#### 机器可读输出

`mo analyze` 和 `mo status` 都支持 `--json` 参数,便于脚本化和自动化。

`mo status` 还会在输出被管道重定向(非终端)时自动检测并切换为 JSON。

```bash
# 磁盘分析输出为 JSON
$ mo analyze --json ~/Documents
{
  "path": "/Users/you/Documents",
  "overview": false,
  "entries": [
    { "name": "Library", "path": "...", "size": 80939438080, "is_dir": true },
    ...
  ],
  "large_files": [
    { "name": "backup.zip", "path": "...", "size": 8796093022 }
  ],
  "total_size": 168393441280,
  "total_files": 42187
}

# 系统状态输出为 JSON
$ mo status --json
{
  "host": "MacBook-Pro",
  "health_score": 92,
  "cpu": { "usage": 45.2, "logical_cpu": 8, ... },
  "memory": { "total": 25769803776, "used": 15049334784, "used_percent": 58.4 },
  "disks": [ ... ],
  "uptime": "3d 12h 45m",
  ...
}

# 管道重定向时自动输出 JSON
$ mo status | jq '.health_score'
92
```

### 项目构建产物清理

清理 `node_modules`、`target`、`.build`、`build`、`dist` 等旧构建产物以释放磁盘空间。

```bash
mo purge

选择要清理的类别 - 18.5GB (已选 8)

➤ ● my-react-app       3.2GB | node_modules
  ● old-project        2.8GB | node_modules
  ● rust-app           4.1GB | target
  ● next-blog          1.9GB | node_modules
  ○ current-work       856MB | node_modules  | 最近
  ● django-api         2.3GB | venv
  ● vue-dashboard      1.7GB | node_modules
  ● backend-service    2.5GB | node_modules
```

> 注意:建议在 macOS 上安装 `fd`。
> `brew install fd`

> 安全:此操作会永久删除所选构建产物。确认前请仔细检查。7 天内的项目默认被标记且不选中。

<details>
<summary><strong>自定义扫描路径</strong></summary>

运行 `mo purge --paths` 配置扫描目录,或直接编辑 `~/.config/mole/purge_paths`:

```shell
~/Documents/MyProjects
~/Work/ClientA
~/Work/ClientB
```

配置自定义路径后,Mole 只扫描这些目录。否则,它会使用 `~/Projects`、`~/GitHub` 和 `~/dev` 等默认目录。

</details>

### 安装包清理

在下载、桌面、Homebrew 缓存、iCloud 和邮件中查找并移除大型安装包文件。每个文件都会标注来源。

```bash
mo installer

选择要移除的安装包 - 3.8GB (已选 5)

➤ ● Photoshop_2024.dmg     1.2GB | 下载
  ● IntelliJ_IDEA.dmg       850.6MB | 下载
  ● Illustrator_Setup.pkg   920.4MB | 下载
  ● PyCharm_Pro.dmg         640.5MB | Homebrew
  ● Acrobat_Reader.dmg      220.4MB | 下载
  ○ AppCode_Legacy.zip      410.6MB | 下载
```

## 快速启动器

从 Raycast 或 Alfred 启动 Mole 命令:

```bash
curl -fsSL https://raw.githubusercontent.com/XiaoWoUi/Mole-CN/main/scripts/setup-quick-launchers.sh | bash
```

添加 5 个命令:`Mole 清理`、`Mole 卸载`、`Mole 优化`、`Mole 分析`、`Mole 状态`。

### Raycast 配置

运行脚本后,请在 Raycast 中完成以下步骤:

1. 打开 Raycast 设置 (⌘ + ,)
2. 进入 **扩展** → **脚本命令**
3. 点击 **"添加脚本目录"**(或 **"+"**)
4. 添加路径: `~/Library/Application Support/Raycast/script-commands`
5. 在 Raycast 中搜索 **"重新加载脚本目录"** 并运行
6. 完成!搜索 `Mole 清理` 或 `clean`、`Mole 优化`、`Mole 状态` 即可使用这些命令

> **注意**:脚本会创建命令,但 Raycast 仍需要一次性手动设置脚本目录。

### 终端识别

Mole 会自动识别你的终端应用。iTerm2 存在已知兼容性问题。我们强烈推荐 [Kaku](https://github.com/tw93/Kaku)。其他不错的选择有 Alacritty、kitty、WezTerm、Ghostty 和 Warp。如需覆盖,请设置 `MO_LAUNCHER_APP=<name>`。

## 社区之爱

感谢每一位帮助构建 Mole 的人。去关注他们吧。❤️

<a href="https://github.com/XiaoWoUi/Mole-CN/graphs/contributors">
  <img src="./CONTRIBUTORS.svg?v=2" width="1000" />
</a>

<br/><br/>
用户在 X 上分享 Mole 的真实反馈。

<img src="https://gw.alipayobjects.com/zos/k/dl/lovemole.jpeg" alt="社区对 Mole 的反馈" width="1000" />

## 支持

- 获取 [Mole for Mac](https://mole.fit) 是支持 Mole 开发最直接的方式。
- 如果 Mole 帮助到了你,给它点个 Star、[分享出去](https://twitter.com/intent/tweet?url=https://github.com/XiaoWoUi/Mole-CN&text=Mole-CN%20-%20%E6%B7%B1%E5%BA%A6%E6%B8%85%E7%90%86%E5%B9%B6%E4%BC%98%E5%8C%96%E4%BD%A0%E7%9A%84%20Mac.),或者提 issue 或 PR。
- 我有两只猫,汤圆和可乐。如果你觉得 Mole 让你的生活更美好,可以请它们吃 <a href="https://cats.tw93.fun?name=Mole" target="_blank">罐头 🥩</a>。

<details>
<summary>这些可爱的人已经做过啦 🐱</summary>
<br/>
<a href="https://cats.tw93.fun?name=Mole"><img src="https://cdn.jsdelivr.net/gh/tw93/sponsors@main/assets/sponsors.svg" width="1000" loading="lazy" /></a>
</details>

## 许可协议

Mole 在 GPL-3.0 下开源,详见 [LICENSE](LICENSE)。你修改并分享的版本同样保持该许可协议开源;如果你将 Mole fork 成自己的产品,为避免混淆,请给它起一个不同的名字并注明 Mole 为来源。[Mole for Mac](https://mole.fit) 是独立的商业应用,Mole 会长期维护下去。
