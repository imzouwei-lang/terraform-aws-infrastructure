# 快速参考

## 关键信息

**IAM Role ARN** (用于GitHub Actions):
```
arn:aws:iam::058264116877:role/GitHubActionsTerraformRole
```

**S3 Backend配置**:
```hcl
backend "s3" {
  bucket         = "terraform-state-058264116877"
  key            = "infrastructure/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-state-lock"
  encrypt        = true
}
```

## GitHub Secrets（不需要配置）

使用OIDC，无需配置AWS_ACCESS_KEY_ID和AWS_SECRET_ACCESS_KEY！

## 工作流触发条件

- **Plan**: PR到main分支，修改`terraform/**`
- **Apply**: 推送到main分支，修改`terraform/**`，需要approval

## 常用命令

### 本地测试
```bash
cd terraform
terraform init
terraform plan
terraform validate
terraform fmt
```

### 更新IAM角色信任策略（限制特定仓库）
```bash
# 编辑 trust-policy-specific-repo.json，替换YOUR_GITHUB_ORG和YOUR_REPO_NAME
aws iam update-assume-role-policy \
  --role-name GitHubActionsTerraformRole \
  --policy-document file://trust-policy-specific-repo.json
```

### 查看Terraform状态
```bash
aws s3 ls s3://terraform-state-058264116877/infrastructure/
```

### 解锁State（紧急情况）
```bash
terraform force-unlock <LOCK_ID>
```

## 故障排查

### GitHub Actions认证失败
1. 检查OIDC Provider是否存在
2. 验证IAM角色信任策略
3. 确认仓库路径匹配

### Terraform初始化失败
1. 检查S3 bucket是否存在
2. 验证DynamoDB表是否ACTIVE
3. 确认IAM角色有S3和DynamoDB权限

### Apply卡住等待
1. 检查GitHub Environment是否配置
2. 确认审批者已添加
3. 在Actions页面手动批准
