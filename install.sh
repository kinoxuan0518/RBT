#!/bin/bash
set -e

# ─────────────────────────────────────────────
# RBT Installer
# https://github.com/kinoxuan0518/RBT
# ─────────────────────────────────────────────

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 使用绝对路径，避免从其他目录调用时出错
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "🚀 RBT (Release BossZhipin Time) Installer"
echo "─────────────────────────────────────────"

# ── 0. 依赖检查 ───────────────────────────────
for cmd in git python3; do
    if ! command -v $cmd &>/dev/null; then
        echo -e "${RED}✗ 未找到 $cmd，请先安装后重试${NC}"
        exit 1
    fi
done
echo -e "${GREEN}✓ 依赖检查通过（git, python3）${NC}"

# ── 1. 检测平台 ───────────────────────────────
if [ -d "$HOME/.codex" ]; then
    PLATFORM="codex"
    SKILLS_DIR="$HOME/.codex/skills"
    echo -e "${GREEN}✓ 检测到 Codex 环境${NC}"
elif [ -d "$HOME/.claude" ]; then
    PLATFORM="claude-code"
    SKILLS_DIR="$HOME/.rbt/skills"
    echo -e "${GREEN}✓ 检测到 Claude Code 环境${NC}"
else
    PLATFORM="generic"
    SKILLS_DIR="$HOME/.rbt/skills"
    echo -e "${YELLOW}⚠ 未检测到已知 AI 工具，使用通用路径：$SKILLS_DIR${NC}"
fi

CACHE_DIR="$HOME/.rbt/cache"

# ── 2. 创建目录 ───────────────────────────────
mkdir -p "$SKILLS_DIR"
mkdir -p "$CACHE_DIR"
echo -e "${GREEN}✓ 目录已创建${NC}"

# ── 3. 安装依赖 skill ─────────────────────────
echo ""
echo "📦 安装依赖 skills..."

install_skill() {
    local repo=$1
    local name=$2
    local target="$SKILLS_DIR/$name"

    if [ -d "$target" ]; then
        echo -e "  ${YELLOW}↻ $name 已存在，正在更新...${NC}"
        git -C "$target" pull --quiet || echo -e "  ${YELLOW}⚠ 更新失败，使用现有版本${NC}"
    else
        echo -e "  ↓ 正在安装 $name..."
        if ! git clone --quiet "https://github.com/kinoxuan0518/$repo.git" "$target"; then
            echo -e "  ${RED}✗ 安装 $name 失败，请检查网络或 GitHub 访问${NC}"
            exit 1
        fi
    fi
    echo -e "  ${GREEN}✓ $name${NC}"
}

install_skill "bosszhibin-auto-recruiter-skill" "bosszhibin-auto-recruiter"
install_skill "bosszhibin-message-resume-handler" "bosszhibin-message-resume-handler"

# ── 4. 安装 RBT 编排 skill ────────────────────
echo ""
echo "📦 安装 RBT 编排层..."
mkdir -p "$SKILLS_DIR/rbt/references"
cp "$SCRIPT_DIR/skills/rbt/SKILL.md" "$SKILLS_DIR/rbt/SKILL.md"
echo -e "${GREEN}✓ rbt${NC}"

# ── 5. 配置环境变量 ───────────────────────────
echo ""
CONFIG_FILE="$SCRIPT_DIR/config.env"

if [ ! -f "$CONFIG_FILE" ]; then
    cp "$SCRIPT_DIR/config.env.template" "$CONFIG_FILE"
    echo -e "${YELLOW}⚠ 已创建 config.env，请填入你的飞书配置后重新运行：${NC}"
    echo -e "   ${YELLOW}source config.env${NC}"
    echo ""
    echo "  需要填写的字段："
    echo "  - FEISHU_APP_ID"
    echo "  - FEISHU_APP_SECRET"
    echo "  - FEISHU_BITABLE_APP_TOKEN"
    echo "  - FEISHU_TABLE_CANDIDATE_MASTER"
    echo "  - FEISHU_TABLE_INTERACTION_LOG"
    echo "  - FEISHU_TABLE_JOB_FUNNEL_DAILY"
else
    source "$CONFIG_FILE"
    echo -e "${GREEN}✓ 环境变量已加载${NC}"
fi

# ── 6. Codex 自动化配置 ───────────────────────
if [ "$PLATFORM" = "codex" ]; then
    echo ""
    echo "⚙️  配置 Codex 定时自动化..."
    AUTOMATION_DIR="$HOME/.codex/automations/rbt"
    mkdir -p "$AUTOMATION_DIR"

    if [ ! -f "$AUTOMATION_DIR/automation.toml" ]; then
        cat > "$AUTOMATION_DIR/automation.toml" << TOML
version = 1
id = "rbt"
name = "RBT 晨间招聘流程"
prompt = "使用 [\$rbt]($SKILLS_DIR/rbt/SKILL.md) 开始晨间流程"
status = "PAUSED"
rrule = "RRULE:FREQ=WEEKLY;BYHOUR=10;BYMINUTE=0;BYDAY=MO,TU,WE,TH,FR"
execution_environment = "local"
cwds = ["$HOME"]
TOML
        echo -e "${GREEN}✓ Codex 自动化已创建（默认暂停，在 Codex 中启用）${NC}"
    else
        echo -e "${YELLOW}⚠ Codex 自动化已存在，跳过${NC}"
    fi
fi

# ── 7. macOS 检查 ─────────────────────────────
echo ""
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${YELLOW}⚠ 当前系统非 macOS。${NC}"
    echo -e "  RBT 使用 AppleScript + Chrome 控制浏览器，需要 macOS 才能运行。"
fi

# ── 完成 ──────────────────────────────────────
echo ""
echo "─────────────────────────────────────────"
echo -e "${GREEN}✅ RBT 安装完成！${NC}"
echo ""
echo "下一步："
echo "  1. 编辑 config.env，填入飞书配置"
echo "  2. 打开 Chrome，登录 BOSS 直聘企业端"
echo "  3. 在你的 AI 工具中说：rbt 开始晨间流程"
echo ""
echo "飞书同步脚本路径："
echo "  $SKILLS_DIR/bosszhibin-auto-recruiter/scripts/feishu_candidate_sync.py"
echo ""
if [ "$PLATFORM" = "codex" ]; then
    echo "  Codex 用户：在 Codex 中前往 Automations → rbt → 启用"
    echo ""
fi
