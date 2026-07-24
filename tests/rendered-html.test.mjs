import assert from "node:assert/strict";
import { access, readFile } from "node:fs/promises";
import test from "node:test";

test("keeps the complete personal portfolio content", async () => {
  const [page, layout] = await Promise.all([
    readFile(new URL("../app/page.tsx", import.meta.url), "utf8"),
    readFile(new URL("../app/layout.tsx", import.meta.url), "utf8"),
  ]);

  assert.match(page, /Life is too interesting/);
  assert.match(page, /My Playground/);
  assert.match(page, /Learn in Public/);
  assert.match(page, /Next Step/);
  assert.match(page, /Join Me/);
  assert.match(page, /Let&apos;s build together!/);
  assert.match(page, /小猫电视台/);
  assert.match(page, /小猫游戏机/);
  assert.match(page, /站一下/);
  assert.match(page, /小猫文学输入器/);
  assert.match(page, /https:\/\/game\.catv\.space/);
  assert.match(page, /https:\/\/tiny\.catv\.space/);
  assert.match(page, /https:\/\/chat\.catv\.space/);
  assert.match(page, /project-preview-link/);
  assert.match(page, /Open project/);
  assert.match(page, /mailto:jessica@relife365\.cn/);
  assert.match(page, /\/contact-lark\.jpg/);
  assert.match(page, /\/contact-wechat\.jpg/);
  assert.match(page, /飞书联系人二维码/);
  assert.match(page, /微信联系人二维码/);
  assert.match(layout, /og-business\.png/);

  await access(new URL("../public/hero-jessica.jpg", import.meta.url));
  await access(new URL("../public/og-business.png", import.meta.url));
  await access(new URL("../public/contact-lark.jpg", import.meta.url));
  await access(new URL("../public/contact-wechat.jpg", import.meta.url));
});

test("uses the standard Next.js build for Vercel", async () => {
  const packageJson = JSON.parse(
    await readFile(new URL("../package.json", import.meta.url), "utf8"),
  );

  assert.equal(packageJson.scripts.dev, "next dev");
  assert.equal(packageJson.scripts.build, "next build");
  assert.equal(packageJson.scripts.start, "next start");
  assert.equal(packageJson.engines.node, "22.x");
  assert.ok(packageJson.dependencies.next);
  assert.equal(packageJson.devDependencies.vinext, undefined);
  assert.equal(packageJson.devDependencies.wrangler, undefined);
  assert.equal(packageJson.devDependencies["@cloudflare/vite-plugin"], undefined);

  await assert.rejects(access(new URL("../vite.config.ts", import.meta.url)));
  await assert.rejects(access(new URL("../worker", import.meta.url)));
  await assert.rejects(access(new URL("../db", import.meta.url)));
});
