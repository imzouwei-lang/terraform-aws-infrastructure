# Terraform GitHub Actions CI/CD

## 架构说明

此配置使用GitHub Actions + Terraform + AWS OIDC实现无密钥的基础设施即代码部署。

### 组件

1. **GitHub OIDC Provider**: 允许GitHub Actions通过OIDC获取临时AWS凭证
2. **IAM Role**: `GitHubActionsTerraformRole` - GitHub Actions使用的执行角色
3. **S3 Bucket**: `terraform-state-058264116877` - 存储Terraform状态文件
4. **DynamoDB Table**: `terraform-state-lock` - 状态文件锁定

### 工作流程

#### Pull Request流程
1. 开发者创建PR修改`terraform/`目录下的文件
2. GitHub Actions自动触发`terraform-plan`任务
3. Plan结果自动评论到PR中
4. 团队成员review变更

#### 部署流程（需要Approval）
1. PR合并到main分支
2. GitHub Actions触发`terraform-apply`任务
3. **需要在GitHub仓库中配置Environment保护规则**
4. 指定审批者批准后，自动执行apply

## 配置步骤

### 1. 在GitHub仓库中配置Environment

进入仓库 Settings → Environments → New environment

创建名为 `production` 的环境，配置：

- **Required reviewers**: 添加需要审批的用户/团队
- **Wait timer**: 可选，设置等待时间
- **Deployment branches**: 限制只能从main分支部署

### 2. 更新信任策略（可选）

如果要限制特定仓库，修改IAM角色信任策略：

```bash
aws iam update-assume-role-policy \
  --role-name GitHubActionsTerraformRole \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::058264116877:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR_ORG/YOUR_REPO:ref:refs/heads/main",
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      }
    }]
  }'
```

### 3. 创建GitHub仓库并推送代码

```bash
# 创建新仓库或使用现有仓库
git init
git add .
git commit -m "Initial Terraform setup"
git branch -M main
git remote add origin https://github.com/YOUR_ORG/YOUR_REPO.git
git push -u origin main
```

### 4. 目录结构

```
.
├── .github/
│   └── workflows/
│       └── terraform-cicd.yml
└── terraform/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── resources.tf
```

## 使用方法

### 测试变更

1. 创建新分支：
```bash
git checkout -b feature/add-vpc
```

2. 修改Terraform配置（例如取消注释`resources.tf`中的VPC）

3. 提交并创建PR：
```bash
git add terraform/
git commit -m "Add VPC resource"
git push origin feature/add-vpc
```

4. 在GitHub上创建Pull Request，查看自动生成的Plan

### 部署变更

1. Review并批准PR
2. 合并PR到main分支
3. 在GitHub Actions中等待审批通知
4. 指定的审批者批准后，自动执行apply

## AWS资源信息

- **OIDC Provider**: `arn:aws:iam::058264116877:oidc-provider/token.actions.githubusercontent.com`
- **IAM Role**: `arn:aws:iam::058264116877:role/GitHubActionsTerraformRole`
- **S3 Bucket**: `terraform-state-058264116877`
- **DynamoDB Table**: `terraform-state-lock`
- **Region**: `us-east-1`

## 安全最佳实践

1. ✅ 使用OIDC而非长期凭证
2. ✅ 启用S3版本控制
3. ✅ 使用DynamoDB锁防止并发修改
4. ✅ 需要人工审批才能部署
5. ✅ 所有变更通过PR review
6. ⚠️ 当前角色有管理员权限，生产环境建议使用最小权限原则

## 故障排查

### 认证失败
- 检查OIDC Provider是否正确配置
- 验证IAM角色信任策略中的仓库路径

### State锁定
```bash
# 手动解锁（谨慎使用）
terraform force-unlock LOCK_ID
```

### Plan失败
- 检查Terraform语法：`terraform fmt -check`
- 验证配置：`terraform validate`
