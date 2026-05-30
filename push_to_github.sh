#!/usr/bin/env bash
#
# Survey System 一键推送脚本
# 用法：在解压后的 survey-system 目录内运行  bash push_to_github.sh
#
# 说明：token 由你在本地交互输入，不会被写入任何文件、不经过聊天记录。
#
set -e

echo "=============================================="
echo "  Survey System → GitHub 推送"
echo "=============================================="
echo
echo "前置条件（请先在浏览器完成）："
echo "  1. 已撤销之前泄露的旧 token"
echo "  2. 已生成一个新的 token（scope 勾选 repo）"
echo "  3. 已在 GitHub 网页建好一个空仓库（名称 Survey-system，不要勾 README）"
echo
read -p "以上都完成了吗？(y/n) " ready
[ "$ready" != "y" ] && echo "请先完成前置条件再运行。" && exit 1

read -p "你的 GitHub 用户名: " GH_USER
read -p "仓库名 (默认 Survey-system): " GH_REPO
GH_REPO=${GH_REPO:-Survey-system}

# token 用 -s 静默读取，屏幕上不显示
read -s -p "粘贴你的新 token（输入时不显示，粘贴后回车）: " GH_TOKEN
echo

# 确保是 git 仓库
[ ! -d .git ] && git init -q && git add -A && git commit -q -m "Initial commit: Survey System v1.0"

git branch -M main

# 用临时 remote 推送，token 不落盘到 git config
REMOTE_URL="https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git"
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${GH_USER}/${GH_REPO}.git"

echo "推送中..."
git push "$REMOTE_URL" main

# 清掉含 token 的变量
unset GH_TOKEN REMOTE_URL

echo
echo "✅ 完成！访问： https://github.com/${GH_USER}/${GH_REPO}"
echo "（提醒：远程地址已存为不含 token 的安全形式，后续 push 会单独提示认证）"
