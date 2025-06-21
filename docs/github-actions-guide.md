# aRDP项目GitHub Actions构建指南

## 概述

我们为aRDP项目创建了一个完整的GitHub Actions workflow，用于自动化构建Android应用。这个workflow会在代码推送或创建Pull Request时自动触发，生成可用的APK文件。

## Workflow功能

### 主要功能
- ✅ 自动构建aRDP Android应用
- ✅ 生成调试版和发布版APK
- ✅ 运行单元测试
- ✅ 缓存依赖以加速构建
- ✅ 上传构建产物到GitHub
- ✅ 详细的构建日志和报告

### 触发条件
- 推送到`main`或`master`分支
- 创建或更新Pull Request
- 手动触发（workflow_dispatch）

## 测试验证步骤

### 1. 准备工作

#### 1.1 确保项目文件完整
```bash
# 检查必要的文件是否存在
ls -la download-prebuilt-dependencies.sh
ls -la bVNC/prepare_project.sh
ls -la gradlew
```

#### 1.2 提交workflow文件
```bash
# 添加workflow文件到git
git add .github/workflows/build-ardp.yml
git commit -m "Add GitHub Actions workflow for aRDP build"
git push origin master
```

### 2. 手动触发测试

#### 2.1 通过GitHub界面手动触发
1. 打开GitHub仓库页面
2. 点击 `Actions` 标签
3. 选择 `Build aRDP Android App` workflow
4. 点击 `Run workflow` 按钮
5. 选择分支并点击绿色的 `Run workflow` 按钮

#### 2.2 通过代码提交触发
```bash
# 创建一个测试提交
echo "# GitHub Actions Test" >> test-build.md
git add test-build.md
git commit -m "Test: trigger GitHub Actions build"
git push origin master
```

### 3. 监控构建过程

#### 3.1 查看构建状态
1. 在GitHub仓库的Actions页面查看workflow运行状态
2. 点击具体的workflow run查看详细日志
3. 观察每个步骤的执行情况

#### 3.2 关键步骤检查
重点关注以下步骤的执行结果：
- ✅ `Download prebuilt dependencies` - 下载预构建依赖
- ✅ `Prepare project` - 项目准备
- ✅ `Build Debug APK` - 构建调试版APK
- ✅ `Build Release APK` - 构建发布版APK（可能失败，正常）
- ✅ `Upload APK artifacts` - 上传构建产物

### 4. 验证构建结果

#### 4.1 下载APK文件
1. 在workflow完成后，点击workflow run页面
2. 在页面底部找到 `Artifacts` 部分
3. 下载 `aRDP-APKs` 压缩包
4. 解压后可以看到生成的APK文件

#### 4.2 验证APK文件
```bash
# 检查APK文件信息（如果有Android SDK）
aapt dump badging aRDP-app-debug.apk

# 或者简单检查文件大小
ls -lh *.apk
```

### 5. 常见问题排查

#### 5.1 依赖下载失败
如果 `Download prebuilt dependencies` 步骤失败：
- 检查网络连接
- 验证 `download-prebuilt-dependencies.sh` 脚本是否可执行
- 查看具体的错误信息

#### 5.2 项目准备失败
如果 `Prepare project` 步骤失败：
- 检查 `bVNC/prepare_project.sh` 脚本权限
- 验证脚本参数是否正确
- 查看具体的错误输出

#### 5.3 构建失败
如果APK构建失败：
- 检查Android SDK版本兼容性
- 验证Gradle版本是否正确
- 查看构建日志中的具体错误信息

### 6. 性能优化

#### 6.1 缓存效果验证
- 第一次运行会比较慢（需要下载所有依赖）
- 后续运行应该会明显加速（利用缓存）
- 在workflow日志中查看 `Cache Gradle packages` 的命中情况

#### 6.2 构建时间监控
正常情况下：
- 首次构建：15-30分钟
- 缓存命中后：5-15分钟
- 仅代码更改：3-10分钟

### 7. 高级验证

#### 7.1 多分支测试
```bash
# 创建测试分支
git checkout -b test/github-actions
echo "Test branch build" >> README.md
git add README.md
git commit -m "Test branch build"
git push origin test/github-actions

# 创建Pull Request测试
# 在GitHub界面创建PR，观察是否触发构建
```

#### 7.2 并行构建测试
如果需要同时构建多个模块，可以在workflow中添加矩阵构建：
```yaml
strategy:
  matrix:
    module: [aRDP-app, aSPICE-app, bVNC-app]
```

### 8. 故障排除指南

#### 8.1 查看详细日志
1. 点击失败的workflow run
2. 点击失败的步骤
3. 展开日志查看具体错误
4. 搜索关键错误信息

#### 8.2 常见错误解决
- **权限错误**: 确保脚本有执行权限
- **依赖错误**: 检查网络和依赖源
- **内存不足**: workflow已配置4GB内存
- **超时**: 检查是否有死循环或网络问题

### 9. 成功标准

构建成功的标志：
- ✅ 所有workflow步骤都是绿色
- ✅ 在Artifacts中能下载到APK文件
- ✅ APK文件大小合理（通常几MB到几十MB）
- ✅ 如果有测试，测试报告显示通过

### 10. 后续优化建议

1. **代码签名**: 配置release版本的签名
2. **自动化测试**: 添加更多的单元测试和集成测试
3. **通知机制**: 配置构建失败时的通知
4. **多平台支持**: 如果需要，可以添加其他架构的构建

## 联系支持

如果在测试过程中遇到问题：
1. 查看GitHub Actions日志获取详细错误信息
2. 检查项目的BUILDING文档
3. 验证本地构建是否正常
4. 参考这个指南进行排查

记住：第一次设置GitHub Actions可能需要一些调试，这是正常的过程！ 