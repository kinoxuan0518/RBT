# RBT — Release BossZhipin Time

一句话启动完整的 BOSS 直聘招聘闭环：主动打招呼 → 消息处理 → 简历评估 → 飞书上传。

```
rbt 开始晨间流程
```

## 系统要求

- macOS（浏览器控制依赖 AppleScript）
- Google Chrome（已登录 BOSS 直聘企业端）
- Python 3
- Codex / Claude Code / Qoderwork / 任何支持 bash 的 AI 工具

## 安装

```bash
git clone https://github.com/kinoxuan0518/RBT.git
cd RBT
./install.sh
```

`install.sh` 会自动完成：
- 检测你使用的 AI 工具（Codex / Claude Code / 其他）
- 安装 `bosszhibin-auto-recruiter` 和 `bosszhibin-message-resume-handler`
- 安装 RBT 编排层
- 生成 `config.env` 供你填写飞书配置
- （Codex 用户）创建定时自动化

## 配置飞书

安装完成后编辑 `config.env`：

```bash
FEISHU_APP_ID=cli_xxxxxxxxxxxxxxxx
FEISHU_APP_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
FEISHU_BITABLE_APP_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
FEISHU_TABLE_CANDIDATE_MASTER=tblxxxxxxxxxxxxxxxx
FEISHU_TABLE_INTERACTION_LOG=tblxxxxxxxxxxxxxxxx
FEISHU_TABLE_JOB_FUNNEL_DAILY=tblxxxxxxxxxxxxxxxx
```

如何获取这些值：见 [`docs/feishu-setup.md`](docs/feishu-setup.md)

配置完成后：

```bash
source config.env
```

## 使用

打开 Chrome，登录 BOSS 直聘企业端，然后在你的 AI 工具中：

| 命令 | 效果 |
|------|------|
| `rbt 开始晨间流程` | 打招呼 → 消息 → 简历 → 飞书上传 |
| `rbt 开始晚间流程` | 消息 → 简历 → 飞书上传 |
| `rbt 开始完整流程` | 完整闭环（含补招） |
| `rbt 状态` | 查看当前进度 |
| `rbt 停止` | 安全停止 |
| `rbt 自我进化` | 分析飞书数据，优化筛选规则 |

### Codex 用户

安装后在 Codex → Automations → rbt 中启用定时触发（工作日早 10:00）。

### Claude Code 用户

```
@rbt 开始晨间流程
```

## 工作原理

RBT 是纯编排层，不直接操作浏览器，由下游两个 skill 完成实际执行：

```
RBT（编排）
  ├── bosszhibin-auto-recruiter    → 主动打招呼
  └── bosszhibin-message-resume-handler → 消息/简历/飞书
```

浏览器控制方式：`osascript → AppleScript → Chrome JS 注入`，无需任何额外 MCP 或插件。

## 技能依赖

| 技能 | 仓库 | 说明 |
|------|------|------|
| bosszhibin-auto-recruiter | [链接](https://github.com/kinoxuan0518/bosszhibin-auto-recruiter-skill) | 自动打招呼 |
| bosszhibin-message-resume-handler | [链接](https://github.com/kinoxuan0518/bosszhibin-message-resume-handler) | 消息与简历处理 |

`install.sh` 会自动安装，无需手动 clone。

## 项目结构

```
RBT/
├── install.sh                    # 一键安装脚本
├── config.env.template           # 环境变量模板
├── skills/
│   └── rbt/SKILL.md              # RBT 编排 skill
├── automations/
│   └── codex.toml.template       # Codex 定时触发模板
├── specs/                        # 接口契约与架构文档
├── docs/                         # 详细文档
└── examples/                     # 示例配置
```

## License

Apache-2.0
