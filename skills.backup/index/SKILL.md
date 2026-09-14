---
name: index
description: 本 Skill Volume 的總目錄：列出所有 skill、用途、套用時機、套用順序與新增 skill 標準。
whenToUse: 需要查看 volume 全貌、確認 skill 套用順序、或新增/擴充 skill 時。
---

# Skill Volume Index

本檔是 volume 的總目錄（meta-skill）：不執行任務，只提供查表與擴充規範。

## 現有 Skills

| # | Skill | 路徑 | 用途 | 套用時機 |
|---|-------|------|------|----------|
| 1 | dev-environment | `.dsh/skills/dev-environment/SKILL.md` | 固定環境認知：runtime、工具、專案邊界、安全編輯規範 | 開始本機開發、修改、執行、測試或除錯前 |
| 2 | git-auto-branch | `.dsh/skills/git-auto-branch/SKILL.md` | 任務層級 Branch 管理：一任務一工作 Branch，禁止自行 Merge | 開始任何自主開發任務前 |
| 3 | git-auto-commit | `.dsh/skills/git-auto-commit/SKILL.md` | 依邏輯完成單位自動 Commit；任務完後 Push 工作 Branch，不 Push 正式 Branch | 自主開發期間；任務完成後 |
| 4 | git-init-repo | `.dsh/skills/git-init-repo/SKILL.md` | 專案無 Git 資料時，先向使用者詢問（名稱/remote/權限/認證）再初始化 | 專案沒有 `.git`、無 remote、尚未 git init |
| 5 | index | `.dsh/skills/index/SKILL.md` | 本總目錄：查表 + 新增 skill 標準 | 查看全貌、確認套用順序、新增 skill |

## 典型套用順序

1. `dev-environment` — 先套用環境認知與快速健檢。
2. 若偵測無 Git 資料 → `git-init-repo`（必須先詢問使用者）。
3. 任務開始 → `git-auto-branch`（確認/建立/切換本任務唯一工作 Branch）。
4. 開發期間 → `git-auto-commit`（依完成單位 commit；可先跑必要 test/lint）。
5. 任務完成 → Push 工作 Branch 至 Remote。
6. Merge、正式 Branch、認證與權限決策 → 一律由使用者決定。

## 新增 Skill 標準

- 路徑：`.dsh/skills/<kebab-name>/SKILL.md`
- Front-matter 必填：`name`、`description`、`whenToUse`；可選 `metadata`（例：`short-description`）。
- 名稱慣例：kebab-case、動詞+名詞（例：`git-auto-stash`、`test-run`）。
- 建議章節結構：職責 → 套用時機/前提偵測 → 流程 → 權限邊界（可自動執行 / 不得自行執行）→ 完成回報。
- 風格：繁體中文；條列式；與專案既有規範衝突時優先遵循專案規範。
- 安全紅線：永不要求、輸出或儲存 API keys、密碼、token、私鑰；跨出專案根目錄前必須取得明確核准。
- 新增後：更新本索引「現有 Skills」表格與「典型套用順序」。

## 候選 Skill（未建立，僅供參考）

| 候選 | 職責 | 注意 |
|------|------|------|
| test-run | 依任務相關性跑 test / lint / type check，回報結果與失敗定位 | 只跑相關測試；不強行全量測試 |
| dependency-update | 變更依賴版本前記錄理由與影響，執行前需確認 | 屬「Confirmation Required」類 |
| doc-sync | 程式變更後同步 README/文檔 | 僅使用者要求時 |
| git-auto-stash | 任務期間暫存未決定的變更（stash/restore） | 不得影響他人分支 |

（候選未包含於 volume；建立前需依上述標準撰寫並經使用者確認。）
