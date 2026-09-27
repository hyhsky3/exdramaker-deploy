# Excalidraw 白板 · 定制部署版

[Excalidraw](https://excalidraw.com) 手绘风白板应用的**定制中文版**纯前端构建产物，开箱即用，无需构建、无需数据库、无需登录。

> 本仓库只包含 `build/` 静态产物（无源码、无 package.json），任何静态服务器或静态托管平台均可直接部署。

## 定制功能（相对官方版）

| 功能 | 说明 |
|---|---|
| 去欢迎屏 | 打开即画布，不再弹欢迎界面 |
| 去登录 | 移除右上角 LOGIN 按钮与登录/注册菜单，开箱即用 |
| 幻灯片悬浮窗 | 页码悬停出现红叉可删除该页；点击页码平滑动画居中定位 |
| 录制工具条 | 默认停靠右上角，可拖动；录制画布操作为 mp4 视频 |
| 追加导入 | 汉堡菜单「导入」按钮，导入 `.excalidraw` 文件**追加**到当前画布（不清空） |
| 录制配置持久化 | 摄像头/麦克风/光标/背景等设置存入 localStorage，刷新不丢 |
| 摄像头画中画 | 录制时摄像头圆窗默认位于拍摄区右下角内缩 28px，可拖动 |
| 设备容错 | 摄像头/麦克风缺失时自动降级继续录制并提示，不再整体失败 |

## 本地运行

**方式一：一键启动**

双击 `启动Excalidraw白板.bat`，自动起服务并打开浏览器（需 Python 3）。

**方式二：任意静态服务器**

```bash
python -m http.server 8080 --bind 127.0.0.1 --directory build
# 或
npx serve -l 8080 build
```

访问 http://127.0.0.1:8080

## 部署到静态托管（以 Cloudflare Pages 为例）

1. Fork / 克隆本仓库
2. [Cloudflare Dashboard](https://dash.cloudflare.com) → Workers & Pages → Create → Pages → **Connect to Git**，选中仓库
3. 构建设置：
   - Framework preset：`None`
   - Build command：**留空**
   - Build output directory：**`build`**
4. Save and Deploy，即得 `https://<项目名>.pages.dev`

Vercel / Netlify / GitHub Pages 同理：托管 `build` 目录即可。HTTPS 环境下录制摄像头/麦克风功能可正常使用。

## 目录结构

```
├── build/                  # 静态站点（部署这个目录）
│   ├── index.html          # 入口
│   ├── assets/             # JS/CSS/多语言包
│   ├── fonts/              # 字体
│   └── sw.js               # Service Worker（Workbox 预缓存）
├── 启动Excalidraw白板.bat   # Windows 一键启动
└── .gitignore
```

## 二次修改须知

产物经过压缩混淆，改动需注意：

1. **改任何文件后必须同步更新 `build/sw.js`** 预缓存清单中对应条目的 `revision`（递增版本号），否则浏览器永远读旧缓存
2. 主逻辑在 `build/assets/index-*.js`（约 2.5MB 压缩单行），修改前先备份、用唯一锚点字符串定位替换
3. 页面显示旧版本时，强制刷新一次即可

## 许可

基于 [Excalidraw](https://github.com/excalidraw/excalidraw)（MIT License）构建产物定制。
