#!/usr/bin/env bats

setup_file() {
    PROJECT_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
    export PROJECT_ROOT
}

@test "optimize exposes no manual memory purge task (#1309)" {
	run env PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail
source "$PROJECT_ROOT/lib/core/common.sh"
source "$PROJECT_ROOT/lib/optimize/catalog.sh"
source "$PROJECT_ROOT/lib/optimize/tasks.sh"

for action in "${MOLE_OPTIMIZE_ACTIONS[@]}"; do
    [[ "$action" != "memory_pressure_relief" ]] || exit 1
done
if declare -F is_memory_pressure_high > /dev/null 2>&1; then
    exit 2
fi
if declare -F opt_memory_pressure_relief > /dev/null 2>&1; then
    exit 3
fi
if command grep -nE '(^|[^[:alnum:]_])(/usr/sbin/)?purge([[:space:]]|$)' "$PROJECT_ROOT/lib/optimize/tasks.sh"; then
    exit 4
fi
EOF

	[ "$status" -eq 0 ] || return 1
}

@test "default optimize catalog never restarts Dock (#1300)" {
    run env PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail
source "$PROJECT_ROOT/lib/optimize/catalog.sh"

optimize_catalog_handler_for system_maintenance >/dev/null
if optimize_catalog_handler_for dock_refresh >/dev/null 2>&1; then
    echo "Dock refresh is still registered"
    exit 1
fi
if grep -nE 'killall[[:space:]]+Dock' "$PROJECT_ROOT/lib/optimize/tasks.sh"; then
    echo "Optimize still terminates Dock"
    exit 1
fi
EOF

    [[ "$status" -eq 0 ]] || { echo "$output"; return 1; }
}

@test "optimize catalog preserves the complete public task contract" {
    run env PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail
source "$PROJECT_ROOT/lib/optimize/catalog.sh"

expected=$(cat <<'CONTRACT'
system_maintenance|opt_system_maintenance|DNS 与 Spotlight 检查|DNS 与 Spotlight 检查|刷新 DNS 缓存并检查 Spotlight 状态|true
cache_refresh|opt_cache_refresh|Finder 缓存刷新|Finder 缓存刷新|刷新 QuickLook 缩略图与图标服务缓存|true
saved_state_cleanup|opt_saved_state_cleanup|App 状态清理|App 状态清理|移除过期的应用保存状态(30 天以上)|true
fix_broken_configs|opt_fix_broken_configs|损坏配置修复|损坏配置修复|修复损坏的偏好设置文件|true
network_optimization|opt_network_optimization|网络缓存刷新|网络缓存刷新|优化 DNS 缓存并重启 mDNSResponder|true
sqlite_vacuum|opt_sqlite_vacuum|数据库优化|数据库优化|压缩 Mail、Safari 与 Messages 的 SQLite 数据库(应用运行中则跳过)|true
launch_services_rebuild|opt_launch_services_rebuild|LaunchServices 修复|LaunchServices 修复|修复"打开方式"菜单与文件关联|true
prevent_network_dsstore|opt_prevent_network_dsstore|阻止 Finder 生成 .DS_Store|阻止 Finder 生成 .DS_Store|设置持久化 Finder 偏好,停止在 SMB/AFP/NFS 与 USB 卷上写入 .DS_Store|true
legacy_overrides_audit|opt_legacy_overrides_audit|遗留覆盖项|遗留覆盖项|移除旧调优工具遗留的隐藏 App Nap 与磁盘映像验证覆盖项|true
network_stack_optimize|opt_network_stack_optimize|网络栈刷新|网络栈刷新|刷新路由表与 ARP 缓存以解决网络问题|true
disk_permissions_repair|opt_disk_permissions_repair|权限修复|权限修复|修复用户目录权限问题|true
spotlight_index_optimize|opt_spotlight_index_optimize|Spotlight 优化|Spotlight 优化|搜索缓慢时重建索引(智能检测)|true
spotlight_orphan_rules_cleanup|opt_prune_spotlight_orphan_rules|Spotlight 孤立规则|Spotlight 孤立规则|移除已卸载应用的 Spotlight 搜索规则条目|true
periodic_maintenance|opt_periodic_maintenance|定期维护|定期维护|过期时运行 macOS 每日/每周/每月维护脚本|true
shared_file_list_repair|opt_shared_file_list_repair|共享文件列表|共享文件列表|修复损坏的 Finder 收藏与最近文稿|true
disk_verify|opt_disk_verify|磁盘健康|磁盘健康|验证文件系统完整性|true
login_items_audit|opt_login_items_audit|登录项|登录项审计|审计登录项中的损坏条目|true
quarantine_cleanup|opt_quarantine_cleanup|隔离区数据库清理|隔离区数据库清理|清除 Gatekeeper 下载跟踪历史|true
launch_agents_cleanup|opt_launch_agents_cleanup|Launch Agents 清理|Launch Agents 清理|移除二进制已不存在的损坏 LaunchAgents|true
notification_cleanup|opt_notification_cleanup|通知|通知|清理已送达的旧通知,减小数据库体积|true
coreduet_cleanup|opt_coreduet_cleanup|使用数据|使用数据|清理旧的使用跟踪数据|true
CONTRACT
)

actual=""
for ((index = 0; index < ${#MOLE_OPTIMIZE_ACTIONS[@]}; index++)); do
    printf -v row '%s|%s|%s|%s|%s|%s' \
        "${MOLE_OPTIMIZE_ACTIONS[$index]}" \
        "${MOLE_OPTIMIZE_HANDLERS[$index]}" \
        "${MOLE_OPTIMIZE_HEALTH_NAMES[$index]}" \
        "${MOLE_OPTIMIZE_WHITELIST_NAMES[$index]}" \
        "${MOLE_OPTIMIZE_DESCRIPTIONS[$index]}" \
        "${MOLE_OPTIMIZE_SAFE_VALUES[$index]}"
    actual+="${actual:+$'\n'}$row"
done

[[ "$actual" == "$expected" ]] || { diff -u <(printf '%s\n' "$expected") <(printf '%s\n' "$actual"); exit 1; }
optimize_catalog_validate || exit 1
EOF

    [[ "$status" -eq 0 ]] || { echo "$output"; return 1; }
}

@test "optimize catalog resolves handler and display ownership together" {
    run env PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail
source "$PROJECT_ROOT/lib/optimize/catalog.sh"

[[ "$(optimize_catalog_handler_for cache_refresh)" == "opt_cache_refresh" ]] || exit 1
[[ "$(optimize_catalog_health_name_for cache_refresh)" == "Finder 缓存刷新" ]] || exit 1
if optimize_catalog_health_name_for unknown_action; then
    exit 1
fi
EOF

    [[ "$status" -eq 0 ]] || { echo "$output"; return 1; }
}

@test "health JSON preserves the exact optimization contract" {
    run env PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail
source "$PROJECT_ROOT/lib/check/health_json.sh"

contract_hash=$(
    generate_health_json |
        sed -n '/  "optimizations": \[/,$p' |
        shasum -a 256 |
        awk '{print $1}'
)
expected_hash="4bc2c74d51e747d860bad880c61945cffeadbf9da5cfc11809a640cc48e5ad0d"
if [[ "$contract_hash" != "$expected_hash" ]]; then
    echo "health optimization contract hash: expected $expected_hash, got $contract_hash"
    exit 1
fi
EOF

    [[ "$status" -eq 0 ]] || { echo "$output"; return 1; }
}

@test "optimize whitelist preserves every public task label and action" {
    run env HOME="$BATS_TEST_TMPDIR/home" PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail
source "$PROJECT_ROOT/lib/manage/whitelist.sh"

contract_hash=$(get_optimize_whitelist_items | shasum -a 256 | awk '{print $1}')
expected_hash="3818d5c753cbde3a788a0f4e5dd01664f35f3ffa198c6dfbce3df2b7e903ebd7"
if [[ "$contract_hash" != "$expected_hash" ]]; then
    echo "optimize whitelist contract hash: expected $expected_hash, got $contract_hash"
    exit 1
fi
EOF

    [[ "$status" -eq 0 ]] || { echo "$output"; return 1; }
}

@test "optimize catalog rejects duplicate identities and unsafe tasks" {
    run env PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail

if /bin/bash --noprofile --norc < <(
    awk '!changed && /opt_cache_refresh/ {sub(/opt_cache_refresh/, "opt_system_maintenance"); changed=1} {print}' \
        "$PROJECT_ROOT/lib/optimize/catalog.sh"
); then
    echo "duplicate handler passed validation"
    exit 1
fi

if /bin/bash --noprofile --norc < <(
    awk '!changed && / true$/ {sub(/ true$/, " false"); changed=1} {print}' \
        "$PROJECT_ROOT/lib/optimize/catalog.sh"
); then
    echo "unsafe task passed validation"
    exit 1
fi
EOF

    [[ "$status" -eq 0 ]] || { echo "$output"; return 1; }
    [[ "$output" == *"重复的优化任务处理器: opt_system_maintenance"* ]] || return 1
    [[ "$output" == *"优化任务不适合自动执行: system_maintenance"* ]] || return 1
}

@test "optimize catalog resolves handlers by exact action id" {
    run env PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail
source "$PROJECT_ROOT/lib/optimize/catalog.sh"

if ! handler=$(optimize_catalog_handler_for spotlight_orphan_rules_cleanup); then
    echo "known action did not resolve"
    exit 1
fi
[[ "$handler" == "opt_prune_spotlight_orphan_rules" ]] || exit 1
if optimize_catalog_handler_for unknown_action; then
    echo "unknown action resolved"
    exit 1
fi
EOF

    [[ "$status" -eq 0 ]] || { echo "$output"; return 1; }
}

@test "optimization task module implements every catalog handler" {
    run env HOME="$BATS_TEST_TMPDIR/home" PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail
source "$PROJECT_ROOT/lib/core/common.sh"
source "$PROJECT_ROOT/lib/optimize/tasks.sh"

[[ ${#MOLE_OPTIMIZE_ACTIONS[@]} -eq 21 ]] || exit 1
for handler in "${MOLE_OPTIMIZE_HANDLERS[@]}"; do
    if ! declare -F "$handler" >/dev/null; then
        echo "missing handler: $handler"
        exit 1
    fi
done
EOF

    [[ "$status" -eq 0 ]] || { echo "$output"; return 1; }
}

@test "optimize catalog consumers can be sourced repeatedly" {
    run env HOME="$BATS_TEST_TMPDIR/home" PROJECT_ROOT="$PROJECT_ROOT" /bin/bash --noprofile --norc <<'EOF'
set -euo pipefail
source "$PROJECT_ROOT/lib/core/common.sh"
source "$PROJECT_ROOT/lib/optimize/tasks.sh"
source "$PROJECT_ROOT/lib/optimize/tasks.sh"
source "$PROJECT_ROOT/lib/check/health_json.sh"
source "$PROJECT_ROOT/lib/check/health_json.sh"

declare -F execute_optimization >/dev/null || exit 1
declare -F generate_health_json >/dev/null || exit 1
EOF

    [[ "$status" -eq 0 ]] || { echo "$output"; return 1; }
}
