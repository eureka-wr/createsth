# Handoff — 2026-07-22

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
6. **Let’s build together!** — 合作邀请与联系邮箱

顶部导航仍使用简洁的 `Join Me`，对应最后的合作区域。

## My Playground

- **小猫电视台 / Cat TV** — 为猫咪设计的内容实验；目前没有配置独立项目地址
- **[小猫游戏机 / Cat Arcade](https://game.catv.space)** — 面向猫咪的钓鱼池互动游戏，可按年龄和性格调整游戏节奏
- **[站一下 / Stand for a moment](https://tiny.catv.space)** — 面向久坐办公人群的轻量休息提醒工具
- **[小猫文学输入器 / Cat Literature Editor](https://chat.catv.space)** — 编辑小猫风格聊天故事并导出完整长图

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
- 页面内容：`app/page.tsx`
- 页面样式：`app/globals.css`
- 元数据：`app/layout.tsx`

## 今天的关键提交

- `e90e4f2` — 首次发布个人网站
- `fbbd13d` — 迁移为标准 Next.js，修复 Vercel 构建
- `23c8a5d` — 接入真实 Playground 项目并新增小猫文学输入器

## 验证状态

- `next build`：通过
- TypeScript：通过
- 内容与部署配置测试：2 项通过
- GitHub `main`：与远程同步

## 后续注意事项

- 本次推送后确认 Vercel 最新部署状态为 Ready
- 如果小猫电视台有独立地址，在 `app/page.tsx` 的第一个项目对象中补充 `url`
- Learn in Public 当前内容是网站示例，后续应替换为 Jessica 的真实更新
- 如需修改合作入口，最后区域的锚点为 `#join-me`
