#!/bin/bash

show_clean_help() {
    echo "用法: mo clean [选项]"
    echo ""
    echo "通过移除缓存、日志、临时文件以及已卸载应用的残留文件来释放磁盘空间。"
    echo ""
    echo "选项:"
    echo "  --dry-run, -n     预演清理,不做任何更改"
    echo "  --external PATH   清理已挂载外置卷上的系统元数据"
    echo "  --whitelist       管理受保护路径"
    echo "  --debug           显示详细操作日志"
    echo "  -h, --help        显示此帮助信息"
}

show_installer_help() {
    echo "用法: mo installer [选项]"
    echo ""
    echo "查找并移除安装包文件 (.dmg、.pkg、.iso、.xip、.zip)。"
    echo ""
    echo "选项:"
    echo "  --dry-run         预演安装包清理,不做任何更改"
    echo "  --debug           显示详细操作日志"
    echo "  -h, --help        显示此帮助信息"
}

show_optimize_help() {
    echo "用法: mo optimize [选项]"
    echo ""
    echo "刷新系统缓存与服务,修复安全范围内的维护问题。"
    echo ""
    echo "选项:"
    echo "  --dry-run         预演优化,不做任何更改"
    echo "  --whitelist       管理受保护项目"
    echo "  --debug           显示详细操作日志"
    echo "  -h, --help        显示此帮助信息"
}

show_touchid_help() {
    echo "用法: mo touchid [命令]"
    echo ""
    echo "为 sudo 认证配置 Touch ID。"
    echo ""
    echo "命令:"
    echo "  enable            启用 sudo 的 Touch ID"
    echo "  disable           禁用 sudo 的 Touch ID"
    echo "  status            显示当前 Touch ID 状态"
    echo ""
    echo "选项:"
    echo "  --dry-run         预演 Touch ID 更改,不修改 sudo 配置"
    echo "  -h, --help        显示此帮助信息"
    echo ""
    echo "未提供命令时,将显示交互式菜单。"
}

show_uninstall_help() {
    echo "用法: mo uninstall [选项] [应用名 ...]"
    echo ""
    echo "以交互方式移除应用及其残留文件。"
    echo "也可以直接指定一个或多个应用名来卸载。"
    echo "如果应用已被删除、只剩残留文件,请使用 mo clean。"
    echo ""
    echo "示例:"
    echo "  mo uninstall                  打开交互式应用选择器"
    echo "  mo uninstall slack            卸载 Slack"
    echo "  mo uninstall slack zoom       卸载 Slack 和 Zoom"
    echo "  mo uninstall --dry-run slack  预演 Slack 卸载"
    echo "  mo uninstall --list           显示已安装应用及 mo uninstall 可接受的名字"
    echo ""
    echo "选项:"
    echo "  --list            列出已安装应用及 mo uninstall 可接受的确切名称"
    echo "  --dry-run         预演应用卸载,不做任何更改"
    echo "  --permanent       绕过 macOS 废纸篓,立即 rm -rf"
    echo "  --whitelist       卸载不支持该选项(请使用 clean/optimize)"
    echo "  --debug           显示详细操作日志"
    echo "  -h, --help        显示此帮助信息"
    echo ""
    echo "默认情况下,卸载的文件会进入 macOS 废纸篓,以便可以恢复。"
    echo "使用 --permanent 可跳过废纸篓步骤。"
}
