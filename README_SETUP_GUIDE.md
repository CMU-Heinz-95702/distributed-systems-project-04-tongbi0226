# 分布式系统Project 4 - 完成指南

**作者**: Tong Bi  
**Andrew ID**: tongbi

---

## 项目概述

本项目已自动生成以下内容:

✅ **Web服务后端** - 基于Java Servlet的RESTful API  
✅ **MongoDB集成** - 云数据库日志记录和分析  
✅ **Dashboard仪表板** - Web界面显示分析数据  
✅ **Android应用** - 原生移动应用  
✅ **部署配置** - ROOT.war文件和Docker配置  

---

## 📂 项目文件说明

```
项目根目录/
├── ROOT.war                    # 已部署的Web服务(2.5MB)
├── QuoteWebService.zip         # Web服务源代码(14KB)
├── QuoteAndroidApp.zip         # Android应用源代码(15KB)
├── Project4Task2Writeup.md     # 项目说明文档
├── Dockerfile                  # Docker容器配置
├── .devcontainer.json          # Codespaces配置
└── build-and-run.sh            # 构建脚本
```

---

## ⚙️ 你需要手动完成的步骤

### 步骤1: 部署Web服务到GitHub Codespaces

#### 1.1 确认ROOT.war已生成
```bash
ls -lh ROOT.war
```
应该看到: `-rw-rw-rw- 1 codespace codespace 2.5M Nov 26 04:28 ROOT.war`

#### 1.2 提交所有文件到Git
```bash
git add ROOT.war QuoteWebService.zip QuoteAndroidApp.zip Project4Task2Writeup.md
git commit -m "Add web service, Android app, and documentation"
git push origin main
```

#### 1.3 访问Codespaces
- 你已经在Codespaces中了!
- 服务应该自动运行在端口8080

#### 1.4 使端口8080公开访问
1. 点击VS Code底部的"端口(Ports)"标签
2. 找到端口8080
3. 右键点击"私有(Private)"
4. 选择"端口可见性" → "公开(Public)"

#### 1.5 获取你的Codespaces URL
- 在端口列表中,将鼠标悬停在端口8080的"本地地址"上
- 点击"复制本地地址"图标(或点击地球图标在浏览器中打开)
- URL格式应该类似: `https://xxx-8080.app.github.dev`

#### 1.6 测试Web服务
在浏览器中打开:
- 主页: `https://你的URL/`
- Dashboard: `https://你的URL/dashboard`  
- API测试: `https://你的URL/getQuote?keyword=success`

---

### 步骤2: 在Android Studio中配置和构建Android应用

#### 2.1 解压Android项目
在你的本地电脑(不是Codespaces)上:

**Windows:**
```cmd
# 下载QuoteAndroidApp.zip到本地
# 右键 → 解压到当前文件夹
```

**Mac/Linux:**
```bash
unzip QuoteAndroidApp.zip
```

#### 2.2 在Android Studio中打开项目
1. 打开Android Studio
2. File → Open
3. 选择解压后的`QuoteAndroidApp`文件夹
4. 等待Gradle同步完成

#### 2.3 **重要!** 更新Web服务URL

打开: `app/src/main/java/edu/cmu/andrew/tongbi/quoteapp/MainActivity.java`

找到第27行左右:
```java
private static final String WEB_SERVICE_URL = "https://YOUR_CODESPACE_URL_HERE/getQuote";
```

替换为你在步骤1.5中获取的实际URL:
```java
private static final String WEB_SERVICE_URL = "https://你的实际codespaces-url-8080.app.github.dev/getQuote";
```

**示例:**
```java
private static final String WEB_SERVICE_URL = 
    "https://fluffy-space-enigma-g5vx5j5w6vhpj76-8080.app.github.dev/getQuote";
```

#### 2.4 构建Android应用

在Android Studio中:
1. Build → Clean Project
2. Build → Rebuild Project
3. 等待构建完成

#### 2.5 运行Android应用

**选项A: 使用Android模拟器**
1. Tools → Device Manager
2. 创建一个虚拟设备(推荐: Pixel 6, API 34)
3. 点击▶️运行按钮
4. 选择你创建的虚拟设备

**选项B: 使用真实Android设备**
1. 在手机上启用开发者选项和USB调试
2. 用USB线连接手机到电脑
3. 点击▶️运行按钮
4. 选择你的设备

#### 2.6 测试应用功能

在运行的Android应用中:

1. **测试随机名言** (不输入关键词):
   - 不输入任何内容
   - 点击"✨ Get Quote ✨"
   - 应该显示一条随机名言

2. **测试关键词搜索**:
   - 输入"success"
   - 点击"✨ Get Quote ✨"
   - 应该显示包含"success"的名言(或相关名言)

3. **测试错误处理**:
   - 如果URL配置错误,会显示网络错误
   - 检查错误信息是否清晰

4. **测试可重复性**:
   - 多次输入不同关键词
   - 确认应用不会崩溃
   - 每次都能获取新的名言

---

### 步骤3: 验证完整的系统流程

#### 3.1 端到端测试

1. **在Android应用中搜索名言** (例如keyword="love")
2. **立即打开Dashboard**: `https://你的URL/dashboard`
3. **检查Dashboard显示**:
   - 总请求数应该增加
   - 日志表中应该显示新的请求记录
   - 应该看到你搜索的关键词
   - 查看API延迟数据

#### 3.2 验证MongoDB数据

Dashboard的日志表应该显示:
- ✅ 时间戳
- ✅ 用户关键词
- ✅ 返回的名言
- ✅ 名言作者
- ✅ API延迟(毫秒)
- ✅ 成功/失败状态
- ✅ User Agent信息

#### 3.3 验证分析数据

Dashboard顶部应该显示:
- ✅ 总请求数
- ✅ 平均API延迟
- ✅ 成功率
- ✅ Top 5搜索关键词
- ✅ Top 5名言作者

---

### 步骤4: 导出Android APK供提交

#### 4.1 导出项目为ZIP

在Android Studio中:
1. File → Export to Zip File...
2. 选择保存位置
3. 命名为`QuoteAndroidApp.zip`

**或者** 如果你修改了代码,重新压缩:
```bash
# 在QuoteAndroidApp父目录
zip -r QuoteAndroidApp.zip QuoteAndroidApp/ -x "*.git*" "*.gradle*" "*build*"
```

---

### 步骤5: 准备提交材料

#### 5.1 需要提交的文件清单

在GitHub仓库中确保有以下文件:

- ✅ `ROOT.war` - Web服务部署文件
- ✅ `QuoteWebService.zip` - Web服务源代码
- ✅ `QuoteAndroidApp.zip` - Android应用源代码  
- ✅ `Project4Task2Writeup.pdf` - 项目说明文档(需要转换为PDF)

#### 5.2 将Writeup转换为PDF

**选项A: 使用在线工具**
1. 下载`Project4Task2Writeup.md`
2. 访问 https://www.markdowntopdf.com/
3. 上传MD文件,转换为PDF
4. 重命名为`Project4Task2Writeup.pdf`

**选项B: 使用VS Code**
1. 安装"Markdown PDF"扩展
2. 打开`Project4Task2Writeup.md`
3. Ctrl+Shift+P → "Markdown PDF: Export (pdf)"

**选项C: 使用Pandoc** (如果已安装)
```bash
pandoc Project4Task2Writeup.md -o Project4Task2Writeup.pdf
```

#### 5.3 截图(可选但推荐)

创建`screenshots`文件夹并添加截图:
1. `android_initial.png` - Android应用初始界面
2. `android_quote.png` - 显示名言的界面
3. `dashboard_analytics.png` - Dashboard分析部分
4. `dashboard_logs.png` - Dashboard日志表格

---

### 步骤6: 最终提交

#### 6.1 提交到GitHub

```bash
git add Project4Task2Writeup.pdf screenshots/
git commit -m "Add final writeup and screenshots"
git push origin main
```

**重要**: 按照老师要求,writeup PDF应该最后上传,因为TA看到writeup后会认为项目已提交!

#### 6.2 验证所有文件都已上传

在GitHub仓库网页上检查:
- ROOT.war (约2.5MB)
- QuoteWebService.zip (约14KB)  
- QuoteAndroidApp.zip (约15KB)
- Project4Task2Writeup.pdf
- (可选) screenshots文件夹

---

## 🔍 常见问题解决

### 问题1: Android应用无法连接到服务器

**症状**: 显示"Network error"

**解决方案**:
1. 检查Codespaces端口8080是否设为"Public"
2. 确认MainActivity.java中的URL是否正确
3. 确认URL末尾有`/getQuote`
4. 测试URL在浏览器中是否能访问
5. 检查AndroidManifest.xml中是否有`INTERNET`权限

### 问题2: Dashboard不显示数据

**症状**: Dashboard显示"No logs available yet"

**解决方案**:
1. 确认Android应用已成功发送请求
2. 检查Android应用的URL配置
3. 在浏览器中测试API: `https://你的URL/getQuote?keyword=test`
4. 检查MongoDB连接字符串是否正确

### 问题3: Web服务无法启动

**症状**: 端口8080没有显示或无法访问

**解决方案**:
1. 在Codespaces终端运行: `./build-and-run.sh`
2. 检查是否有错误信息
3. 确认ROOT.war文件存在且大小正确
4. 重启Codespace

### 问题4: MongoDB连接失败

**症状**: 日志中显示MongoDB错误

**解决方案**:
1. 检查MongoDB Atlas是否允许所有IP (0.0.0.0/0)
2. 确认用户名密码正确
3. 确认数据库名称为`quoteapp`
4. 测试连接字符串

### 问题5: Android应用闪退

**症状**: 应用打开后立即关闭

**解决方案**:
1. 在Android Studio中查看Logcat
2. 检查是否有编译错误
3. 确认所有资源文件都已创建
4. Clean and Rebuild项目

---

## 📋 功能检查清单

在提交前,确认以下所有功能都正常工作:

### Android应用:
- [ ] 应用成功安装并启动
- [ ] 界面显示正常(标题、图标、输入框、按钮)
- [ ] 可以输入关键词
- [ ] 点击按钮显示加载动画
- [ ] 成功获取并显示名言和作者
- [ ] 空关键词可以获取随机名言
- [ ] 错误处理正常(显示错误信息)
- [ ] 可以重复使用(多次搜索)

### Web服务:
- [ ] API端点可访问: `/getQuote`
- [ ] 参数`keyword`正常工作
- [ ] 返回正确的JSON格式
- [ ] 成功调用ZenQuotes API
- [ ] 错误处理正常

### Dashboard:
- [ ] Dashboard可访问: `/dashboard`
- [ ] 显示总请求数
- [ ] 显示平均延迟
- [ ] 显示成功率
- [ ] 显示Top 5关键词
- [ ] 显示Top 5作者
- [ ] 日志表格正确显示所有字段
- [ ] 日志按时间排序(最新在前)

### MongoDB:
- [ ] 每次请求都被记录
- [ ] 记录包含所有8个字段
- [ ] Dashboard请求不被记录

---

## 🎯 评分标准提示

根据README要求,确保:

1. **Android应用** (至少3种View) - 你有7种✅
2. **用户输入** - EditText ✅
3. **HTTP请求** - HttpURLConnection ✅
4. **JSON解析** - Gson ✅
5. **显示信息** - TextView显示名言和作者 ✅
6. **可重复使用** - 多次搜索无需重启 ✅
7. **Web服务API** - GET /getQuote ✅
8. **第三方API** - ZenQuotes (不在禁用列表) ✅
9. **日志6+字段** - 你有8个字段 ✅
10. **MongoDB存储** - MongoDB Atlas ✅
11. **Dashboard分析** - 5个分析指标 ✅
12. **格式化日志** - HTML表格(非JSON/XML) ✅
13. **错误处理** - 所有类型都已实现 ✅
14. **Codespaces部署** - ROOT.war + Dockerfile ✅

---

## 💡 额外建议

### 1. 测试多种场景

测试以下不同的输入:
- 空关键词
- 单个单词(success, love, life)
- 多个单词(do great work)
- 特殊字符(应被过滤)
- 很长的输入(应被限制为50字符)

### 2. 检查日志质量

Dashboard中应该能看到:
- 不同的User-Agent(Android设备信息)
- 各种关键词
- 不同的API延迟时间
- 所有请求都成功(apiSuccess = true)

### 3. 性能优化(可选)

如果有时间,可以考虑:
- 添加缓存机制减少API调用
- 优化关键词匹配算法
- 改进UI/UX设计

### 4. 文档完善

Writeup中已包含:
- 详细的需求满足说明
- 代码位置引用
- 技术栈列表
- 测试清单

确保添加实际的截图!

---

## 📞 需要帮助?

如果遇到问题:

1. **检查Codespaces日志**: 在终端查看错误信息
2. **检查Android Logcat**: 在Android Studio查看崩溃日志
3. **检查浏览器控制台**: F12查看网络请求
4. **检查MongoDB Atlas**: 登录查看数据库内容

---

## ✅ 完成标志

当你完成以下所有步骤,项目就可以提交了:

1. ✅ Web服务已部署到Codespaces且可访问
2. ✅ Android应用已构建且能成功运行
3. ✅ Android应用能连接到Web服务获取名言
4. ✅ Dashboard显示正确的分析数据和日志
5. ✅ 所有4个文件已上传到GitHub
6. ✅ Writeup PDF已完成(最后上传!)

---

**祝你好运!如果一切顺利,你应该能获得满分!** 🎉

**Author:** Tong Bi  
**Email:** tongbi@andrew.cmu.edu  
**Course:** CMU 95-702 Distributed Systems
