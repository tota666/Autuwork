#!/bin/bash

# 初始化项目
npm init -y

# 安装 Puppeteer
npm install puppeteer

# 创建 Puppeteer 脚本
cat << 'EOF' > simulate_browser.js
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  
  try {
    const page = await browser.newPage();
    await page.goto('https://example.com');
    const title = await page.title();
    console.log('页面标题:', title);
  } catch (error) {
    console.error('发生错误:', error);
  } finally {
    await browser.close();
  }
})();
EOF

# 创建 GitHub Actions 工作流文件
mkdir -p .github/workflows
cat << 'EOF' > .github/workflows/simulate_browser.yml
name: Simulate Browser Execution

on:
  schedule:
    - cron: '0 * * * *'  # 每小时的第0分钟运行
  push:
    branches:
      - main

jobs:
  run_script:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
      
      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'  # 选择合适的 Node.js 版本
      
      - name: Install dependencies
        run: npm install  # 安装 package.json 中定义的依赖
      
      - name: Run Puppeteer script
        run: node simulate_browser.js  # 运行 Puppeteer 脚本
EOF

echo "项目已设置完成。请将文件提交到 GitHub 仓库。"
