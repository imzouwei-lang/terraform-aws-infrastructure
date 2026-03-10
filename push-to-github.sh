#!/bin/bash
# GitHub用户: imzouwei-lang
# 仓库: terraform-aws-infrastructure

set -e

echo "=== 配置Git用户信息 ==="
git config --global user.name "imzouwei-lang"
git config --global user.email "imzouwei-lang@users.noreply.github.com"

echo ""
echo "=== 初始化Git仓库 ==="
cd /tmp/github-terraform-setup
git init

echo ""
echo "=== 添加所有文件 ==="
git add .

echo ""
echo "=== 创建初始提交 ==="
git commit -m "Initial Terraform setup with GitHub Actions and OIDC"

echo ""
echo "=== 设置主分支 ==="
git branch -M main

echo ""
echo "=== 添加远程仓库 ==="
git remote add origin https://github.com/imzouwei-lang/terraform-aws-infrastructure.git

echo ""
echo "=== 推送到GitHub ==="
echo "注意：需要输入GitHub Personal Access Token作为密码"
echo "如果还没有token，访问: https://github.com/settings/tokens/new"
echo "权限需要: repo (Full control of private repositories)"
echo ""
git push -u origin main

echo ""
echo "✅ 代码已推送到 https://github.com/imzouwei-lang/terraform-aws-infrastructure"
echo ""
echo "下一步："
echo "1. 访问 https://github.com/imzouwei-lang/terraform-aws-infrastructure/settings/environments"
echo "2. 创建 production environment 并添加审批者"
