#!/usr/bin/env bash
# dsh skill volume reinstallation script
# Usage: DSX_SKILLS_DIR=<target> bash install-skills.sh
# Default target: .dsh/skills relative to current directory
set -euo pipefail
ROOT="${DSX_SKILLS_DIR:-.dsh/skills}"
mkdir -p "$ROOT/dev-environment"
cat > "$ROOT/dev-environment/SKILL.md" <<'EOF'
---
name: dev-environment
description: 在開始本機開發、修改、測試或除錯前使用，快速取得 runtime、工具、專案邊界與安全編輯規範，避免重複探索環境。
whenToUse: 開始本機開發、修改、執行、測試或除錯前，先套用本環境認知。
metadata:
  short-description: Local development environment profile
---

# Dev Environment

在進入任何開發、修改、執行或除錯工作前，先套用本 Skill 的固定環境認知。若內容與實際狀態不一致，以實際檢查結果為準並向使用者說明差異。

## Runtime And Tools

- Primary runtime: Python `3.9.7`.
- Installed package manager: `pip 25.0`.
- Available tooling: Git `2.46.0.windows.1`, Node.js `v24.18.1`, npm `11.16.0`, ripgrep, and PowerShell.
- Do not assume additional runtimes, frameworks, build systems, test suites, linters, or application entrypoints exist unless the project explicitly configures them.

## Workspace And Safety Boundary

- Start from the current working directory as the project root.
- All reads, searches, creation, modification, and command execution remain inside that root by default.
- Treat paths outside that root, other repositories, user-level settings, system settings, external drives, and network resources as out of scope unless explicitly approved.
- Do not assume a directory is a Git repository; verify `.git` exists before using Git history or remote operations.
- Ask before hardware health checks, disk diagnostics, network configuration inspection, system logs, installed-software inventories, sensitive environment variables, credentials, or account information.
- Never request, output, or store API keys, passwords, tokens, private keys, or other secrets.

## Editing Rules

- Preserve UTF-8 encoding and original line endings when modifying existing text files.
- Prefer modular design with clear responsibilities and small testable functions.
- Change only the minimum area required by the task.
- Do not refactor, reformat, rename, or move unrelated code without approval.
- After changes, identify modified files and reasons; run only relevant tests when tests exist.

## Confirmation Required

- Installing packages or changing dependency versions.
- Creating top-level files, changing documented architecture, or introducing frameworks.
- Accessing paths outside the project root, modifying system settings, or reading sensitive environment variables.
- Arbitrary network requests.

## Fast Health Check

A minimal non-destructive check is sufficient before normal work:

```powershell
python --version
python -m pip --version
git --version
node --version
npm --version
rg --version
```

If a check fails, diagnose and report the concrete error instead of reinstalling tools or changing configuration automatically.
EOF
mkdir -p "$ROOT/git-auto-branch"
cat > "$ROOT/git-auto-branch/SKILL.md" <<'EOF'
---
name: git-auto-branch
description: 自主開發時管理任務層級的工作 Branch。任務開始時確認或建立並切換單一工作 Branch，開發期間持續使用、不得自行建立新 Branch，任務結束不得自行 Merge。
whenToUse: 開始任何自主開發任務前，確認/建立/切換本任務唯一的工作 Branch。
---

# Git Auto Branch

負責任務層級的 Branch 管理。套用於自主開發任務，確保整個任務期間只使用一個主要工作 Branch，並把 Merge 決策保留給使用者。

## 任務開始

- 確認目前 Repository 與 Branch。
- 若已有目前任務對應的工作 Branch，直接使用。
- 若沒有，建立新的工作 Branch 並切換。
- 一個任務原則上只使用一個主要工作 Branch。

## 開發期間

- 持續使用目前任務的工作 Branch。
- 不得因修改其他檔案、API 或發現額外修改而自行建立新 Branch。
- 只有開始新的獨立任務，或使用者明確要求拆分時，才建立新 Branch。

## Merge

- 不得自行 Merge。
- 不得自行將工作 Branch 合併至 `main`、`master` 或其他正式 Branch。

## 權限邊界

可自動執行：建立任務 Branch、切換任務 Branch。

不得自行執行：Merge、刪除他人 Branch、重寫共享 Branch 歷史、執行高風險 Git 操作。

若專案已有 Git workflow 規範，優先遵循專案規範。
EOF
mkdir -p "$ROOT/git-auto-commit"
cat > "$ROOT/git-auto-commit/SKILL.md" <<'EOF'
---
name: git-auto-commit
description: 自主開發期間依邏輯完成單位自動建立 Commit，任務完成後將工作 Branch Push 至 Remote；不自行 Merge，不 Push 正式 Branch。
whenToUse: 自主開發期間依邏輯完成單位自動建立 Commit；任務完成後 Push 工作 Branch 至 Remote。
---

# Git Auto Commit

負責開發期間的 Commit 與任務完成後的 Push。套用於自主開發任務，讓提交節奏自動化，同時把 Merge 與正式 Branch 的決策保留給使用者。

## 開發期間

- 可依具邏輯意義的完成單位自動建立 Commit。
- Commit 前確認變更與目前任務相關。
- 優先執行必要的 test / lint / type check。
- 遵循專案既有 Commit message 規範。

## 任務完成

- 確認必要修改均已 Commit。
- 將目前工作 Branch Push 至 Remote。
- 不得自行 Push 至 `main`、`master` 或其他正式 Branch。

## Merge

- 不得自行 Merge。
- Merge 必須由使用者決定。

## 權限邊界

可自動執行：`git add`、`git commit`、`git push` 工作 Branch。

不得自行執行：Merge、Push `main` / `master`、刪除他人 Branch、重寫共享 Branch 歷史、執行高風險 Git 操作。

若專案已有 Git workflow 規範，優先遵循專案規範。
EOF
mkdir -p "$ROOT/git-init-repo"
cat > "$ROOT/git-init-repo/SKILL.md" <<'EOF'
---
name: git-init-repo
description: 當 Agent 在專案中偵測不到任何 Git 資料（尚未 git init、無 remote、無 repository）時，由 Agent 協助建立 Git repository；建立前必須向使用者詢問名稱、remote、權限與認證方式。
whenToUse: 專案沒有 .git、無 remote、尚未 git init 時，協助初始化 Git repository（先詢問使用者）。
---

# Git Init Repo

負責一個尚未被 Git 追蹤的專案的初始化。套用時機：Agent 於專案工作目錄執行 `git rev-parse --is-inside-work-tree`（或檢查 `.git`、`git remote`）後，確認專案沒有 Git 資料。

## 套用時機（前提偵測）

在開始建立前，先確認下列條件未滿足，才呼叫本 Skill：

- 不是 Git repo（`git rev-parse --is-inside-work-tree` 回報非 true）。
- 無 `.git` 目錄。
- 無任何 remote（`git remote -v` 為空）。

若已有 repo 或 remote，不適用本 Skill，交由既有 Git 流程處理（例如 git-auto-branch / git-auto-commit）。

## 建立前必須詢問使用者

Agent 不得擅自決定下列資訊，必須逐一以提問方式向使用者確認後才能動手。若使用者未明確回答，不得繼續建立。

1. **Repo 名稱**：本地資料夾或遠端 repo 的名稱。
2. **Remote 設定**：是否要連到遠端（例如 GitHub），以及遠端 URL；若只要本地追蹤，明確確認「僅本地」。
3. **權限／可見性**：遠端 repo 要設為 private 或 public（若適用）。
4. **認證方式**：由使用者決定如何提供 GitHub credential（例如 OAuth / gh CLI / PAT token）。永不要求、輸出或儲存任何 token、密碼或私鑰。

提問時同時說明每項選擇的影響，並依使用者回答的最小範圍執行。

## 建立流程

- 依確認內容執行 `git init`（可用 `-b <main>` 設定初始分支名稱，需先確認）。
- 視需要 `git add` 初始內容並建立初始 commit；commit 前先確認要納入哪些檔案，必要時先設定 `.gitignore`。
- 若使用者要求連線 remote，依其提供的 URL 執行 `git remote add`；推送前先確認認證可用。
- 僅推送使用者指定允許的分支（預設不推 `main`/`master` 以外的分支，也不自行建立多個分支）。

## 權限邊界

可自動執行（在使用者確認後）：`git init`、建立初始 commit、`git remote add`、把允許的分支 push 到使用者指定的 remote。

不得自行執行：未經詢問即建立遠端 repo、幫使用者選擇權限或認證方式、`git push` 至使用者未指定的位置、`git merge`。

## 完成回報

回報時列出：repo 名稱、是否本地/遠端、remote URL、建了哪些 commit、尚未完成（如等待使用者提供認證）。未完成部分交由使用者決定後再繼續。
EOF
echo "Installed skills under $ROOT"
