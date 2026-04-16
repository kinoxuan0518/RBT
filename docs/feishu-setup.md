# 飞书多维表格配置指南

本文档说明如何获取 RBT 运行所需的飞书配置。

## 1. 创建飞书自建应用

1. 访问 [飞书开放平台](https://open.feishu.cn/app)
2. 点击「创建企业自建应用」
3. 填写应用名称（如 `RBT 招聘同步`）
4. 创建完成后，进入应用详情页
5. 在「凭证与基础信息」中获取：
   - `App ID` → 对应 `FEISHU_APP_ID`
   - `App Secret` → 对应 `FEISHU_APP_SECRET`

## 2. 配置应用权限

在应用详情 → 「权限管理」中开启以下权限：

- `bitable:app` — 多维表格读写
- `bitable:app:readonly` — 多维表格只读（进化分析用）

保存后发布应用版本。

## 3. 获取多维表格 Token

1. 打开飞书招聘多维表格
2. 复制浏览器地址栏 URL，格式如：
   ```
   https://xxx.feishu.cn/base/xxxxxxxxxxxxxxxxxxxxxx?table=tblxxxxxxxx
   ```
3. `/base/` 后面的字符串 → `FEISHU_BITABLE_APP_TOKEN`
4. `?table=` 后面的字符串 → 对应某个数据表的 `TABLE_ID`

## 4. 获取各数据表 ID

RBT 需要三张数据表：

| 变量名 | 说明 | 建议表名 |
|--------|------|----------|
| `FEISHU_TABLE_CANDIDATE_MASTER` | 候选人主档 | 候选人库 |
| `FEISHU_TABLE_INTERACTION_LOG` | 交互记录 | 沟通记录 |
| `FEISHU_TABLE_JOB_FUNNEL_DAILY` | 每日漏斗统计 | 漏斗数据 |

在多维表格中，点击每张表的「...」→「表格信息」，或从 URL 的 `?table=` 参数获取 Table ID。

## 5. 给应用授权访问多维表格

1. 在多维表格右上角点击「...」→「更多」→「添加文档应用」
2. 搜索并添加你创建的应用
3. 授权「可编辑」权限

## 6. 填写 config.env

完成上述步骤后，编辑 RBT 根目录的 `config.env`：

```bash
FEISHU_APP_ID=cli_xxxxxxxxxxxxxxxx
FEISHU_APP_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
FEISHU_BITABLE_APP_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
FEISHU_TABLE_CANDIDATE_MASTER=tblxxxxxxxxxxxxxxxx
FEISHU_TABLE_INTERACTION_LOG=tblxxxxxxxxxxxxxxxx
FEISHU_TABLE_JOB_FUNNEL_DAILY=tblxxxxxxxxxxxxxxxx
```

然后执行：

```bash
source config.env
```

## 验证配置

配置完成后可以运行以下命令验证连通性：

```bash
python3 ~/.rbt/skills/bosszhibin-auto-recruiter/scripts/feishu_candidate_sync.py --dry-run
```

（Codex 用户路径为 `~/.codex/skills/bosszhibin-auto-recruiter/scripts/feishu_candidate_sync.py`）
