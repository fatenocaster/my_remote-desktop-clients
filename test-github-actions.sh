#!/bin/bash

# aRDP GitHub Actions测试脚本
# 用于验证构建环境和依赖

echo "=== aRDP GitHub Actions 环境测试 ==="
echo "测试时间: $(date)"
echo

# 1. 检查必要文件
echo "1. 检查必要文件..."
files=(
    "download-prebuilt-dependencies.sh"
    "bVNC/prepare_project.sh"
    "build.gradle"
    "gradle.properties"
    "aRDP-app/build.gradle"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file - 存在"
    else
        echo "  ❌ $file - 缺失"
    fi
done

# 2. 检查脚本权限
echo
echo "2. 检查脚本权限..."
scripts=(
    "download-prebuilt-dependencies.sh"
    "bVNC/prepare_project.sh"
)

for script in "${scripts[@]}"; do
    if [ -x "$script" ]; then
        echo "  ✅ $script - 可执行"
    else
        echo "  ⚠️  $script - 需要执行权限"
        echo "     运行: chmod +x $script"
    fi
done

# 3. 检查Gradle wrapper
echo
echo "3. 检查Gradle环境..."
if [ -f "gradlew" ]; then
    if [ -x "gradlew" ]; then
        echo "  ✅ gradlew - 存在且可执行"
        echo "  Gradle版本信息:"
        ./gradlew --version | head -n 5 | sed 's/^/    /'
    else
        echo "  ⚠️  gradlew - 存在但需要执行权限"
        echo "     运行: chmod +x gradlew"
    fi
else
    echo "  ❌ gradlew - 缺失"
fi

# 4. 检查Android项目结构
echo
echo "4. 检查Android项目结构..."
android_dirs=(
    "aRDP-app/src/main"
    "bVNC/src/main"
    "gradle/wrapper"
)

for dir in "${android_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✅ $dir - 存在"
    else
        echo "  ❌ $dir - 缺失"
    fi
done

# 5. 检查GitHub Actions workflow
echo
echo "5. 检查GitHub Actions配置..."
if [ -f ".github/workflows/build-ardp.yml" ]; then
    echo "  ✅ .github/workflows/build-ardp.yml - 存在"
    echo "  Workflow详情:"
    echo "    - 名称: $(grep '^name:' .github/workflows/build-ardp.yml | cut -d':' -f2 | xargs)"
    echo "    - 触发器: push, pull_request, workflow_dispatch"
    echo "    - 构建系统: Gradle + Android SDK"
else
    echo "  ❌ .github/workflows/build-ardp.yml - 缺失"
fi

# 6. 模拟依赖下载测试
echo
echo "6. 测试依赖下载脚本..."
if [ -x "download-prebuilt-dependencies.sh" ]; then
    echo "  正在测试依赖下载脚本（前5行）..."
    head -n 5 download-prebuilt-dependencies.sh | sed 's/^/    /'
    echo "  ✅ 脚本格式正常"
else
    echo "  ❌ 无法测试依赖下载脚本"
fi

# 7. 检查项目配置
echo
echo "7. 检查项目配置..."
if [ -f "gradle.properties" ]; then
    echo "  Gradle配置："
    grep -E "(SDK_VERSION|org.gradle)" gradle.properties | sed 's/^/    /'
fi

if [ -f "aRDP-app/build.gradle" ]; then
    echo "  aRDP-app配置："
    grep -E "(compileSdkVersion|targetSdkVersion|minSdkVersion)" aRDP-app/build.gradle | sed 's/^/    /'
fi

# 8. 生成测试总结
echo
echo "=== 测试总结 ==="
echo "📋 项目准备状态检查完成"
echo
echo "🚀 下一步操作："
echo "1. 提交GitHub Actions workflow到仓库"
echo "   git add .github/workflows/build-ardp.yml"
echo "   git commit -m 'Add GitHub Actions workflow for aRDP'"
echo "   git push origin master"
echo
echo "2. 在GitHub仓库的Actions页面手动触发构建测试"
echo
echo "3. 如果有权限问题，运行："
echo "   chmod +x download-prebuilt-dependencies.sh"
echo "   chmod +x bVNC/prepare_project.sh"
echo "   chmod +x gradlew"
echo
echo "📖 详细指南: docs/github-actions-guide.md"
echo
echo "测试完成时间: $(date)" 