# Handoff — 2026-07-25

## 项目概况

这是 Jessica 的个人创作者网站，用于介绍她是谁、正在制作的产品、公开学习记录、下一步方向，以及合作邀请。

- Slogan：`Life is too interesting to stop trying.`
- 联系邮箱：`jessica@relife365.cn`
- GitHub：<https://github.com/eureka-wr/createsth>
- 生产部署：Vercel 连接 GitHub `main` 分支自动部署

## 当前页面结构

1. **Home** — 个人定位、兴趣方向与首屏照片
2. **What I Can Bring** — 产品思考、快速原型、AI 共创、内容表达
3. **My Playground** — 已完成或持续迭代的产品项目
4. **Learn in Public** — AI 与产品制作过程中的学习记录
5. **Next Step** — 下一阶段方向与对应的 WHY
6. **Let’s build together!** — 合作邀请、联系邮箱，以及飞书和微信二维码

顶部导航仍使用简洁的 `Join Me`，对应最后的合作区域。

## My Playground

- **小猫电视台 / Cat TV** — 为猫咪设计的内容实验；目前没有配置独立项目地址
- **[小猫游戏机 / Cat Arcade](https://game.catv.space)** — 面向猫咪的钓鱼池互动游戏，可按年龄和性格调整游戏节奏
- **[站一下 / Stand for a moment](https://tiny.catv.space)** — 面向久坐办公人群的轻量休息提醒工具
- **[小猫文学输入器 / Cat Literature Editor](https://chat.catv.space)** — 编辑小猫风格聊天故事并导出完整长图

带有真实地址的项目支持点击预览图片或卡片底部链接，在新标签页打开对应产品。

## 技术与部署

- 框架：Next.js 16 App Router
- Node.js：22.x
- 包管理器：pnpm
- 样式：全局 CSS + Tailwind PostCSS 基础配置
- 构建命令：`pnpm build` → `next build`
- 测试命令：`pnpm test`

项目最初基于 vinext / Cloudflare Worker 脚手架。Vercel 会把含有 `next` 的项目识别为标准 Next.js，并要求 `.next` 构建产物，因此旧的 `vinext build` 在 Vercel 上会因为找不到 `.next` 而失败。

2026-07-22 已完成以下迁移：

- 构建命令改为标准 `next dev` / `next build` / `next start`
- 移除 vinext、Wrangler、Cloudflare Vite 插件和 Worker 入口
- 移除未使用的 D1、Drizzle、Sites 登录与示例代码
- 删除重复的 npm lockfile，统一使用 `pnpm-lock.yaml`
- 将 Node.js 版本固定为 22.x

## 主要资源

- 首屏照片：`public/hero-jessica.jpg`
- 分享封面：`public/og-business.png`
- 飞书联系二维码：`public/contact-lark.jpg`
- 微信联系二维码：`public/contact-wechat.jpg`
- 页面内容：`app/page.tsx`
- 页面样式：`app/globals.css`
- 元数据：`app/layout.tsx`

## 微信视频号个人介绍片

已制作一支 42 秒个人品牌介绍视频，内容沿用网站的个人定位、真实项目与合作邀请。

- 成片：`deliverables/wechat-video/output/jessica-wechat-video.mp4`
- 视频号封面：`deliverables/wechat-video/output/jessica-wechat-cover.png`
- 外挂字幕：`deliverables/wechat-video/output/jessica-wechat-video.srt`
- 分镜与发布文案：`deliverables/wechat-video/storyboard.md`
- 制作源文件：`deliverables/wechat-video/source/`
- 规格：1080 × 1920、9:16、42 秒、H.264 视频 + AAC 音频
- 内容结构：品牌 Slogan → Jessica 自我介绍 → 个人网站 → 三个 Playground 项目 → 工作方法 → Learn in Public → 合作邀请
- 音频：中文旁白、原创轻量环境音乐、内嵌大字幕

重新生成时，在项目根目录运行：

```bash
./deliverables/wechat-video/source/build_video.sh
```

## 今天的关键提交

- Playground 项目预览图已支持直接点击并跳转到对应产品
- 在最后的合作区域加入飞书和微信二维码卡片，桌面端并排、移动端纵向显示
- 二维码保留完整原图比例和留白，避免裁切影响识别
- 制作适配微信视频号的竖屏个人品牌介绍片，并补齐封面、字幕、分镜和可复用生成脚本

## 验证状态

- `next build`：通过
- TypeScript：通过
- 内容与部署配置测试：2 项通过
- GitHub `main`：与远程同步

## 后续注意事项

- 本次推送后确认 Vercel 最新部署状态为 Ready
- 视频发布前可直接使用 `jessica-wechat-cover.png` 作为封面，发布文案见 `storyboard.md`
- 如果小猫电视台有独立地址，在 `app/page.tsx` 的第一个项目对象中补充 `url`
- Learn in Public 当前内容是网站示例，后续应替换为 Jessica 的真实更新
- 如需修改合作入口，最后区域的锚点为 `#join-me`，二维码卡片样式在 `app/globals.css` 的 `.contact-*` 规则中
