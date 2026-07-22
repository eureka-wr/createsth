import type { Metadata } from "next";
import { headers } from "next/headers";
import "./globals.css";

export async function generateMetadata(): Promise<Metadata> {
  const requestHeaders = await headers();
  const host = requestHeaders.get("host") ?? "localhost:3000";
  const protocol = host.includes("localhost") || host.startsWith("127.0.0.1") ? "http" : "https";
  const base = new URL(`${protocol}://${host}`);

  return {
    metadataBase: base,
    title: "Still Trying — 产品创造、AI 学习与持续实验",
    description: "一个持续动手的产品创作者：制作小工具与互动体验，公开学习 AI，也期待与你一起创造。",
    icons: { icon: "/favicon.svg" },
    openGraph: {
      title: "Life is too interesting to stop trying.",
      description: "产品创造、AI 学习与持续实验。欢迎交流想法，或一起做出新的东西。",
      type: "website",
      images: [{ url: new URL("/og-business.png", base), width: 1672, height: 941, alt: "Life is too interesting to stop trying." }],
    },
    twitter: {
      card: "summary_large_image",
      title: "Life is too interesting to stop trying.",
      description: "产品创造、AI 学习与持续实验。欢迎交流想法，或一起做出新的东西。",
      images: [new URL("/og-business.png", base)],
    },
  };
}

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="zh-CN">
      <body>{children}</body>
    </html>
  );
}
