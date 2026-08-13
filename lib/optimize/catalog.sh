#!/bin/bash
# Canonical optimization task metadata and handler ownership.

set -euo pipefail

if [[ -n "${MOLE_OPTIMIZE_CATALOG_LOADED:-}" ]]; then
    return 0
fi
readonly MOLE_OPTIMIZE_CATALOG_LOADED=1

# The catalog uses aligned arrays instead of serialized records. This keeps
# field boundaries explicit on Bash 3.2 and lets each consumer read only the
# projection it owns. Every registered task is safe for automatic execution.
MOLE_OPTIMIZE_ACTIONS=()
MOLE_OPTIMIZE_HANDLERS=()
MOLE_OPTIMIZE_HEALTH_NAMES=()
MOLE_OPTIMIZE_WHITELIST_NAMES=()
MOLE_OPTIMIZE_DESCRIPTIONS=()
MOLE_OPTIMIZE_SAFE_VALUES=()

_optimize_catalog_register() {
    local index=${#MOLE_OPTIMIZE_ACTIONS[@]}
    MOLE_OPTIMIZE_ACTIONS[index]="$1"
    MOLE_OPTIMIZE_HANDLERS[index]="$2"
    MOLE_OPTIMIZE_HEALTH_NAMES[index]="$3"
    MOLE_OPTIMIZE_WHITELIST_NAMES[index]="$4"
    MOLE_OPTIMIZE_DESCRIPTIONS[index]="$5"
    MOLE_OPTIMIZE_SAFE_VALUES[index]="$6"
}

_optimize_catalog_register system_maintenance opt_system_maintenance \
    "DNS 与 Spotlight 检查" "DNS 与 Spotlight 检查" \
    "刷新 DNS 缓存并检查 Spotlight 状态" true
_optimize_catalog_register cache_refresh opt_cache_refresh \
    "Finder 缓存刷新" "Finder 缓存刷新" \
    "刷新 QuickLook 缩略图与图标服务缓存" true
_optimize_catalog_register saved_state_cleanup opt_saved_state_cleanup \
    "App 状态清理" "App 状态清理" \
    "移除过期的应用保存状态(30 天以上)" true
_optimize_catalog_register fix_broken_configs opt_fix_broken_configs \
    "损坏配置修复" "损坏配置修复" \
    "修复损坏的偏好设置文件" true
_optimize_catalog_register network_optimization opt_network_optimization \
    "网络缓存刷新" "网络缓存刷新" \
    "优化 DNS 缓存并重启 mDNSResponder" true
_optimize_catalog_register sqlite_vacuum opt_sqlite_vacuum \
    "数据库优化" "数据库优化" \
    "压缩 Mail、Safari 与 Messages 的 SQLite 数据库(应用运行中则跳过)" true
_optimize_catalog_register launch_services_rebuild opt_launch_services_rebuild \
    "LaunchServices 修复" "LaunchServices 修复" \
    '修复"打开方式"菜单与文件关联' true
_optimize_catalog_register prevent_network_dsstore opt_prevent_network_dsstore \
    "阻止 Finder 生成 .DS_Store" "阻止 Finder 生成 .DS_Store" \
    "设置持久化 Finder 偏好,停止在 SMB/AFP/NFS 与 USB 卷上写入 .DS_Store" true
_optimize_catalog_register legacy_overrides_audit opt_legacy_overrides_audit \
    "遗留覆盖项" "遗留覆盖项" \
    "移除旧调优工具遗留的隐藏 App Nap 与磁盘映像验证覆盖项" true
_optimize_catalog_register network_stack_optimize opt_network_stack_optimize \
    "网络栈刷新" "网络栈刷新" \
    "刷新路由表与 ARP 缓存以解决网络问题" true
_optimize_catalog_register disk_permissions_repair opt_disk_permissions_repair \
    "权限修复" "权限修复" \
    "修复用户目录权限问题" true
_optimize_catalog_register spotlight_index_optimize opt_spotlight_index_optimize \
    "Spotlight 优化" "Spotlight 优化" \
    "搜索缓慢时重建索引(智能检测)" true
_optimize_catalog_register spotlight_orphan_rules_cleanup opt_prune_spotlight_orphan_rules \
    "Spotlight 孤立规则" "Spotlight 孤立规则" \
    "移除已卸载应用的 Spotlight 搜索规则条目" true
_optimize_catalog_register periodic_maintenance opt_periodic_maintenance \
    "定期维护" "定期维护" \
    "过期时运行 macOS 每日/每周/每月维护脚本" true
_optimize_catalog_register shared_file_list_repair opt_shared_file_list_repair \
    "共享文件列表" "共享文件列表" \
    "修复损坏的 Finder 收藏与最近文稿" true
_optimize_catalog_register disk_verify opt_disk_verify \
    "磁盘健康" "磁盘健康" \
    "验证文件系统完整性" true
_optimize_catalog_register login_items_audit opt_login_items_audit \
    "登录项" "登录项审计" \
    "审计登录项中的损坏条目" true
_optimize_catalog_register quarantine_cleanup opt_quarantine_cleanup \
    "隔离区数据库清理" "隔离区数据库清理" \
    "清除 Gatekeeper 下载跟踪历史" true
_optimize_catalog_register launch_agents_cleanup opt_launch_agents_cleanup \
    "Launch Agents 清理" "Launch Agents 清理" \
    "移除二进制已不存在的损坏 LaunchAgents" true
_optimize_catalog_register notification_cleanup opt_notification_cleanup \
    "通知" "通知" \
    "清理已送达的旧通知,减小数据库体积" true
_optimize_catalog_register coreduet_cleanup opt_coreduet_cleanup \
    "使用数据" "使用数据" \
    "清理旧的使用跟踪数据" true

optimize_catalog_index_for() {
    local requested_action="$1"
    local index
    for ((index = 0; index < ${#MOLE_OPTIMIZE_ACTIONS[@]}; index++)); do
        if [[ "${MOLE_OPTIMIZE_ACTIONS[$index]}" == "$requested_action" ]]; then
            printf '%s\n' "$index"
            return 0
        fi
    done
    return 1
}

optimize_catalog_handler_for() {
    local index
    index=$(optimize_catalog_index_for "$1") || return 1
    printf '%s\n' "${MOLE_OPTIMIZE_HANDLERS[$index]}"
}

optimize_catalog_health_name_for() {
    local index
    index=$(optimize_catalog_index_for "$1") || return 1
    printf '%s\n' "${MOLE_OPTIMIZE_HEALTH_NAMES[$index]}"
}

optimize_catalog_validate() {
    local count=${#MOLE_OPTIMIZE_ACTIONS[@]}
    if [[ $count -eq 0 ]]; then
        echo "优化任务目录为空" >&2
        return 1
    fi
    if [[ ${#MOLE_OPTIMIZE_HANDLERS[@]} -ne $count ||
        ${#MOLE_OPTIMIZE_HEALTH_NAMES[@]} -ne $count ||
        ${#MOLE_OPTIMIZE_WHITELIST_NAMES[@]} -ne $count ||
        ${#MOLE_OPTIMIZE_DESCRIPTIONS[@]} -ne $count ||
        ${#MOLE_OPTIMIZE_SAFE_VALUES[@]} -ne $count ]]; then
        echo "优化任务目录字段未对齐" >&2
        return 1
    fi

    local seen_actions="|"
    local seen_handlers="|"
    local index action handler
    for ((index = 0; index < count; index++)); do
        action=${MOLE_OPTIMIZE_ACTIONS[$index]}
        handler=${MOLE_OPTIMIZE_HANDLERS[$index]}
        if [[ ! "$action" =~ ^[a-z0-9_]+$ || ! "$handler" =~ ^opt_[a-z0-9_]+$ ]]; then
            echo "无效的优化任务标识: $action|$handler" >&2
            return 1
        fi
        if [[ -z "${MOLE_OPTIMIZE_HEALTH_NAMES[$index]}" ||
            -z "${MOLE_OPTIMIZE_WHITELIST_NAMES[$index]}" ||
            -z "${MOLE_OPTIMIZE_DESCRIPTIONS[$index]}" ]]; then
            echo "优化任务元数据不完整: $action" >&2
            return 1
        fi
        if [[ "${MOLE_OPTIMIZE_SAFE_VALUES[$index]}" != "true" ]]; then
            echo "优化任务不适合自动执行: $action" >&2
            return 1
        fi
        if [[ "$seen_actions" == *"|$action|"* ]]; then
            echo "重复的优化任务动作: $action" >&2
            return 1
        fi
        if [[ "$seen_handlers" == *"|$handler|"* ]]; then
            echo "重复的优化任务处理器: $handler" >&2
            return 1
        fi
        seen_actions+="$action|"
        seen_handlers+="$handler|"
    done
}

optimize_catalog_validate
readonly -a MOLE_OPTIMIZE_ACTIONS
readonly -a MOLE_OPTIMIZE_HANDLERS
readonly -a MOLE_OPTIMIZE_HEALTH_NAMES
readonly -a MOLE_OPTIMIZE_WHITELIST_NAMES
readonly -a MOLE_OPTIMIZE_DESCRIPTIONS
readonly -a MOLE_OPTIMIZE_SAFE_VALUES
unset -f _optimize_catalog_register
