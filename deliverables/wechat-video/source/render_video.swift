import AppKit
import AVFoundation
import CoreVideo
import Foundation

let width = 1080
let height = 1920
let fps: Int32 = 30
let duration = 42.0

let paper = NSColor(calibratedRed: 0.953, green: 0.937, blue: 0.906, alpha: 1)
let ink = NSColor(calibratedRed: 0.110, green: 0.161, blue: 0.153, alpha: 1)
let terracotta = NSColor(calibratedRed: 0.757, green: 0.427, blue: 0.306, alpha: 1)
let sage = NSColor(calibratedRed: 0.545, green: 0.655, blue: 0.604, alpha: 1)
let sageLight = NSColor(calibratedRed: 0.866, green: 0.902, blue: 0.875, alpha: 1)
let muted = NSColor(calibratedRed: 0.430, green: 0.455, blue: 0.435, alpha: 1)
let white = NSColor.white

struct Assets {
    let hero: NSImage
    let portfolio: NSImage
    let arcade: NSImage
    let stand: NSImage
    let literature: NSImage
}

enum RenderError: Error {
    case missingAsset(String)
    case cannotCreateWriter
    case cannotCreatePixelBuffer
    case cannotCreateContext
    case appendFailed
    case writerFailed(String)
}

func loadImage(_ path: String) throws -> NSImage {
    guard let image = NSImage(contentsOfFile: path) else {
        throw RenderError.missingAsset(path)
    }
    return image
}

func clamp(_ value: Double, _ low: Double = 0, _ high: Double = 1) -> Double {
    min(high, max(low, value))
}

func smooth(_ value: Double) -> Double {
    let t = clamp(value)
    return t * t * (3 - 2 * t)
}

func sceneProgress(_ time: Double, start: Double, length: Double) -> Double {
    smooth((time - start) / length)
}

func fadeIn(_ time: Double, start: Double, length: Double = 0.7) -> CGFloat {
    CGFloat(smooth((time - start) / length))
}

func fill(_ color: NSColor, _ rect: NSRect) {
    color.setFill()
    rect.fill()
}

func roundedRect(_ rect: NSRect, radius: CGFloat, color: NSColor) {
    color.setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}

func strokeRoundedRect(_ rect: NSRect, radius: CGFloat, color: NSColor, lineWidth: CGFloat = 2) {
    color.setStroke()
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    path.lineWidth = lineWidth
    path.stroke()
}

func font(_ name: String, _ size: CGFloat, weight: NSFont.Weight = .regular) -> NSFont {
    NSFont(name: name, size: size) ?? NSFont.systemFont(ofSize: size, weight: weight)
}

func drawText(
    _ text: String,
    rect: NSRect,
    font: NSFont,
    color: NSColor,
    alignment: NSTextAlignment = .left,
    lineSpacing: CGFloat = 0,
    tracking: CGFloat = 0,
    alpha: CGFloat = 1
) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = alignment
    paragraph.lineSpacing = lineSpacing
    paragraph.lineBreakMode = .byWordWrapping

    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: color.withAlphaComponent(alpha),
        .paragraphStyle: paragraph,
        .kern: tracking,
    ]
    (text as NSString).draw(in: rect, withAttributes: attributes)
}

func drawImage(
    _ image: NSImage,
    in rect: NSRect,
    fillMode: Bool,
    alignTop: Bool = false,
    zoom: CGFloat = 1,
    alpha: CGFloat = 1,
    radius: CGFloat = 0
) {
    let imageSize = image.size
    let scale = (fillMode
        ? max(rect.width / imageSize.width, rect.height / imageSize.height)
        : min(rect.width / imageSize.width, rect.height / imageSize.height)) * zoom
    let drawSize = NSSize(width: imageSize.width * scale, height: imageSize.height * scale)
    let x = rect.midX - drawSize.width / 2
    let y = alignTop ? rect.minY : rect.midY - drawSize.height / 2
    let destination = NSRect(origin: NSPoint(x: x, y: y), size: drawSize)

    NSGraphicsContext.saveGraphicsState()
    if radius > 0 {
        NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).addClip()
    } else {
        NSBezierPath(rect: rect).addClip()
    }
    image.draw(
        in: destination,
        from: .zero,
        operation: .sourceOver,
        fraction: alpha,
        respectFlipped: true,
        hints: [.interpolation: NSImageInterpolation.high]
    )
    NSGraphicsContext.restoreGraphicsState()
}

func drawPill(_ text: String, x: CGFloat, y: CGFloat, width: CGFloat, color: NSColor, textColor: NSColor) {
    let rect = NSRect(x: x, y: y, width: width, height: 58)
    roundedRect(rect, radius: 29, color: color)
    drawText(
        text,
        rect: NSRect(x: x, y: y + 18, width: width, height: 28),
        font: font("Arial", 18, weight: .bold),
        color: textColor,
        alignment: .center,
        tracking: 1.2
    )
}

func drawSubtitle(_ text: String, time: Double, start: Double, end: Double) {
    guard time >= start, time <= end else { return }
    let alpha = min(
        fadeIn(time, start: start, length: 0.35),
        fadeIn(end - time, start: 0, length: 0.35)
    )
    let rect = NSRect(x: 84, y: 1630, width: 912, height: 126)
    roundedRect(rect, radius: 24, color: ink.withAlphaComponent(0.78 * alpha))
    drawText(
        text,
        rect: NSRect(x: 120, y: 1660, width: 840, height: 74),
        font: font("STHeitiSC-Medium", 32, weight: .medium),
        color: white,
        alignment: .center,
        lineSpacing: 8,
        alpha: alpha
    )
}

func drawSceneOne(_ time: Double) {
    fill(paper, NSRect(x: 0, y: 0, width: width, height: height))
    let p = sceneProgress(time, start: 0, length: 4)
    let titleAlpha = fadeIn(time, start: 0.15, length: 0.8)
    let rise = CGFloat(1 - p) * 38

    fill(terracotta.withAlphaComponent(0.15), NSRect(x: 760, y: -90, width: 420, height: 420))
    roundedRect(NSRect(x: 94, y: 116, width: 58, height: 58), radius: 29, color: ink)
    drawText(
        "S",
        rect: NSRect(x: 94, y: 130, width: 58, height: 38),
        font: font("Georgia-Bold", 25, weight: .bold),
        color: white,
        alignment: .center
    )
    drawText(
        "STILL TRYING / A PERSONAL MAKING PRACTICE",
        rect: NSRect(x: 176, y: 134, width: 720, height: 36),
        font: font("Arial-BoldMT", 17, weight: .bold),
        color: ink,
        tracking: 3.2
    )

    drawText(
        "Life is too",
        rect: NSRect(x: 96, y: 390 + rise, width: 900, height: 130),
        font: font("Georgia", 104),
        color: ink,
        alpha: titleAlpha
    )
    drawText(
        "interesting",
        rect: NSRect(x: 96, y: 520 + rise, width: 900, height: 140),
        font: font("Georgia", 112),
        color: ink,
        alpha: titleAlpha
    )
    drawText(
        "to stop",
        rect: NSRect(x: 96, y: 655 + rise, width: 900, height: 140),
        font: font("Georgia", 112),
        color: ink,
        alpha: titleAlpha
    )
    drawText(
        "trying.",
        rect: NSRect(x: 96, y: 790 + rise, width: 900, height: 155),
        font: font("Georgia-Italic", 122),
        color: terracotta,
        alpha: titleAlpha
    )
    drawText(
        "好奇心太多，时间太少。\n所以，继续尝试。",
        rect: NSRect(x: 100, y: 1110, width: 760, height: 150),
        font: font("STHeitiSC-Light", 36),
        color: muted,
        lineSpacing: 15,
        alpha: fadeIn(time, start: 1.0)
    )

    fill(ink.withAlphaComponent(0.15), NSRect(x: 96, y: 1490, width: 888, height: 2))
    fill(terracotta, NSRect(x: 96, y: 1490, width: 888 * CGFloat(p), height: 4))
    drawSubtitle("世界太有意思了，所以我不想停止尝试。", time: time, start: 0.45, end: 3.8)
}

func drawSceneTwo(_ time: Double, assets: Assets) {
    let local = time - 4
    let p = sceneProgress(local, start: 0, length: 5)
    drawImage(
        assets.hero,
        in: NSRect(x: 0, y: 0, width: width, height: height),
        fillMode: true,
        zoom: 1 + CGFloat(p) * 0.045
    )
    fill(ink.withAlphaComponent(0.68), NSRect(x: 0, y: 1050, width: width, height: 870))
    fill(terracotta.withAlphaComponent(0.82), NSRect(x: 78, y: 120, width: 295, height: 54))
    drawText(
        "HELLO / WHO I AM",
        rect: NSRect(x: 98, y: 137, width: 260, height: 30),
        font: font("Arial-BoldMT", 17, weight: .bold),
        color: white,
        tracking: 2.6
    )
    let alpha = fadeIn(local, start: 0.2)
    drawText(
        "你好，我是",
        rect: NSRect(x: 82, y: 1165, width: 850, height: 80),
        font: font("STHeitiSC-Light", 48),
        color: sageLight,
        alpha: alpha
    )
    drawText(
        "Jessica",
        rect: NSRect(x: 78, y: 1240, width: 900, height: 150),
        font: font("Georgia", 120),
        color: white,
        alpha: alpha
    )
    drawText(
        "产品创作者  ·  AI 学习者",
        rect: NSRect(x: 84, y: 1405, width: 900, height: 60),
        font: font("STHeitiSC-Medium", 34, weight: .medium),
        color: white,
        tracking: 2,
        alpha: fadeIn(local, start: 0.8)
    )
    drawSubtitle("你好，我是 Jessica，一个持续动手的产品创作者。", time: time, start: 4.25, end: 8.8)
}

func drawSceneThree(_ time: Double, assets: Assets) {
    let local = time - 9
    let p = sceneProgress(local, start: 0, length: 5)
    fill(sageLight, NSRect(x: 0, y: 0, width: width, height: height))
    drawText(
        "WHAT I’M MAKING",
        rect: NSRect(x: 90, y: 116, width: 650, height: 30),
        font: font("Arial-BoldMT", 17, weight: .bold),
        color: terracotta,
        tracking: 3
    )
    drawText(
        "把好奇心",
        rect: NSRect(x: 86, y: 220, width: 900, height: 110),
        font: font("STHeitiSC-Light", 76),
        color: ink
    )
    drawText(
        "变成可以体验的产品",
        rect: NSRect(x: 86, y: 335, width: 920, height: 120),
        font: font("STHeitiSC-Medium", 66, weight: .medium),
        color: terracotta
    )

    let card = NSRect(x: 92, y: 560 + CGFloat(1 - p) * 28, width: 896, height: 1080)
    roundedRect(NSRect(x: card.minX - 12, y: card.minY + 18, width: card.width + 24, height: card.height + 16), radius: 34, color: ink.withAlphaComponent(0.10))
    roundedRect(card, radius: 28, color: white)
    drawImage(assets.portfolio, in: NSInsetRect(card, 24, 24), fillMode: true, alignTop: true, radius: 18)
    drawSubtitle("我正在学习 AI，也把好奇心变成真的能用、能玩的产品。", time: time, start: 9.1, end: 13.8)
}

func drawProjectScene(
    _ time: Double,
    localStart: Double,
    sceneEnd: Double,
    index: String,
    title: String,
    english: String,
    background: NSColor,
    titleColor: NSColor,
    image: NSImage
) {
    fill(background, NSRect(x: 0, y: 0, width: width, height: height))
    let local = time - localStart
    let alpha = fadeIn(local, start: 0.05, length: 0.38)
    drawText(
        "MY PLAYGROUND / \(index)",
        rect: NSRect(x: 88, y: 96, width: 720, height: 32),
        font: font("Arial-BoldMT", 17, weight: .bold),
        color: titleColor.withAlphaComponent(0.68),
        tracking: 3
    )
    drawText(
        title,
        rect: NSRect(x: 84, y: 170, width: 900, height: 116),
        font: font("STHeitiSC-Medium", 78, weight: .medium),
        color: titleColor,
        alpha: alpha
    )
    drawText(
        english,
        rect: NSRect(x: 90, y: 286, width: 850, height: 40),
        font: font("Arial-BoldMT", 18, weight: .bold),
        color: titleColor.withAlphaComponent(0.68),
        tracking: 2.4,
        alpha: alpha
    )

    let card = NSRect(x: 120, y: 390, width: 840, height: 1170)
    roundedRect(NSRect(x: 104, y: 407, width: 872, height: 1190), radius: 46, color: ink.withAlphaComponent(0.12))
    roundedRect(card, radius: 38, color: white)
    drawImage(image, in: NSInsetRect(card, 22, 22), fillMode: false, radius: 24)
    strokeRoundedRect(card, radius: 38, color: white.withAlphaComponent(0.8), lineWidth: 4)
}

func drawSceneFour(_ time: Double, assets: Assets) {
    if time < 16.7 {
        drawProjectScene(
            time,
            localStart: 14,
            sceneEnd: 16.7,
            index: "01",
            title: "小猫游戏机",
            english: "CAT ARCADE / FOR CATS",
            background: NSColor(calibratedRed: 0.805, green: 0.930, blue: 0.950, alpha: 1),
            titleColor: ink,
            image: assets.arcade
        )
    } else if time < 19.4 {
        drawProjectScene(
            time,
            localStart: 16.7,
            sceneEnd: 19.4,
            index: "02",
            title: "站一下",
            english: "A TINY WELLBEING TOOL",
            background: paper,
            titleColor: ink,
            image: assets.stand
        )
    } else {
        drawProjectScene(
            time,
            localStart: 19.4,
            sceneEnd: 22.2,
            index: "03",
            title: "小猫文学输入器",
            english: "CAT LITERATURE EDITOR",
            background: NSColor(calibratedRed: 0.925, green: 0.914, blue: 0.890, alpha: 1),
            titleColor: ink,
            image: assets.literature
        )
    }
    drawSubtitle(
        "给猫咪做游戏和文学输入器，也给久坐的人做一个提醒站起来的小工具。",
        time: time,
        start: 14.0,
        end: 22.0
    )
}

func drawSceneFive(_ time: Double) {
    let local = time - 22.2
    fill(ink, NSRect(x: 0, y: 0, width: width, height: height))
    drawText(
        "HOW I WORK",
        rect: NSRect(x: 86, y: 106, width: 700, height: 32),
        font: font("Arial-BoldMT", 17, weight: .bold),
        color: sage,
        tracking: 3
    )

    drawText(
        "01",
        rect: NSRect(x: 84, y: 294, width: 80, height: 40),
        font: font("Arial-BoldMT", 20, weight: .bold),
        color: terracotta
    )
    drawText(
        "从一个模糊想法开始",
        rect: NSRect(x: 164, y: 270, width: 820, height: 100),
        font: font("STHeitiSC-Light", 60),
        color: white,
        alpha: fadeIn(local, start: 0.1)
    )
    fill(white.withAlphaComponent(0.16), NSRect(x: 84, y: 405, width: 912, height: 2))

    drawText(
        "02",
        rect: NSRect(x: 84, y: 548, width: 80, height: 40),
        font: font("Arial-BoldMT", 20, weight: .bold),
        color: terracotta
    )
    drawText(
        "快速做成",
        rect: NSRect(x: 156, y: 505, width: 850, height: 170),
        font: font("STHeitiSC-Medium", 112, weight: .medium),
        color: terracotta,
        alpha: fadeIn(local, start: 0.7)
    )
    drawText(
        "可以体验的版本",
        rect: NSRect(x: 156, y: 682, width: 850, height: 110),
        font: font("STHeitiSC-Light", 66),
        color: sageLight,
        alpha: fadeIn(local, start: 1.0)
    )
    fill(white.withAlphaComponent(0.16), NSRect(x: 84, y: 850, width: 912, height: 2))

    drawText(
        "03",
        rect: NSRect(x: 84, y: 1012, width: 80, height: 40),
        font: font("Arial-BoldMT", 20, weight: .bold),
        color: sage
    )
    drawText(
        "再一点点改进。",
        rect: NSRect(x: 156, y: 968, width: 850, height: 130),
        font: font("STHeitiSC-Light", 76),
        color: white,
        alpha: fadeIn(local, start: 1.5)
    )
    drawText(
        "MAKE → TEST → LEARN → REPEAT",
        rect: NSRect(x: 90, y: 1338, width: 900, height: 42),
        font: font("Arial-BoldMT", 19, weight: .bold),
        color: sage.withAlphaComponent(0.8),
        tracking: 3
    )
    drawSubtitle(
        "我喜欢从模糊的想法开始，快速做成可以体验的版本，再一点点改进。",
        time: time,
        start: 22.3,
        end: 28.1
    )
}

func drawSceneSix(_ time: Double) {
    let local = time - 28.3
    fill(sage, NSRect(x: 0, y: 0, width: width, height: height))
    drawText(
        "LEARN IN PUBLIC",
        rect: NSRect(x: 88, y: 118, width: 700, height: 34),
        font: font("Arial-BoldMT", 18, weight: .bold),
        color: ink,
        tracking: 3.4
    )
    fill(ink.withAlphaComponent(0.20), NSRect(x: 88, y: 178, width: 904, height: 2))
    drawText(
        "“",
        rect: NSRect(x: 82, y: 290, width: 120, height: 170),
        font: font("Georgia", 170),
        color: sageLight.withAlphaComponent(0.7)
    )
    drawText(
        "学习不用等到\n准备好。",
        rect: NSRect(x: 86, y: 450, width: 920, height: 340),
        font: font("STHeitiSC-Light", 112),
        color: white,
        lineSpacing: 22,
        alpha: fadeIn(local, start: 0.2)
    )
    drawText(
        "创造，也不必一个人完成。",
        rect: NSRect(x: 92, y: 910, width: 900, height: 90),
        font: font("STHeitiSC-Medium", 48, weight: .medium),
        color: ink,
        alpha: fadeIn(local, start: 0.9)
    )
    for index in 0..<5 {
        let y = CGFloat(1160 + index * 66)
        roundedRect(NSRect(x: 92, y: y, width: 12, height: 12), radius: 6, color: terracotta)
        fill(white.withAlphaComponent(0.25), NSRect(x: 128, y: y + 5, width: CGFloat(720 - index * 70), height: 2))
    }
    drawSubtitle(
        "我相信，学习不用等到准备好，创造也不必一个人完成。",
        time: time,
        start: 28.4,
        end: 33.8
    )
}

func drawSceneSeven(_ time: Double) {
    let local = time - 34
    fill(terracotta, NSRect(x: 0, y: 0, width: width, height: height))
    drawText(
        "OPEN TO COLLABORATION",
        rect: NSRect(x: 88, y: 112, width: 760, height: 34),
        font: font("Arial-BoldMT", 18, weight: .bold),
        color: sageLight,
        tracking: 3.2
    )
    drawText(
        "Let’s build",
        rect: NSRect(x: 78, y: 260, width: 940, height: 150),
        font: font("Georgia", 116),
        color: white,
        alpha: fadeIn(local, start: 0.1)
    )
    drawText(
        "together!",
        rect: NSRect(x: 78, y: 402, width: 940, height: 165),
        font: font("Georgia-Italic", 126),
        color: white,
        alpha: fadeIn(local, start: 0.25)
    )
    drawText(
        "如果你也想创造点什么，\n我们可以先从一次对话开始。",
        rect: NSRect(x: 88, y: 690, width: 900, height: 150),
        font: font("STHeitiSC-Light", 48),
        color: white,
        lineSpacing: 18,
        alpha: fadeIn(local, start: 0.8)
    )

    drawPill("AI PROTOTYPING", x: 88, y: 945, width: 264, color: white.withAlphaComponent(0.14), textColor: white)
    drawPill("PRODUCT", x: 370, y: 945, width: 190, color: white.withAlphaComponent(0.14), textColor: white)
    drawPill("PET EXPERIENCE", x: 578, y: 945, width: 286, color: white.withAlphaComponent(0.14), textColor: white)

    let card = NSRect(x: 88, y: 1160, width: 904, height: 190)
    roundedRect(card, radius: 22, color: paper)
    drawText(
        "START A CONVERSATION",
        rect: NSRect(x: 124, y: 1200, width: 470, height: 28),
        font: font("Arial-BoldMT", 16, weight: .bold),
        color: muted,
        tracking: 2.2
    )
    drawText(
        "jessica@relife365.cn",
        rect: NSRect(x: 124, y: 1250, width: 750, height: 60),
        font: font("Arial", 35),
        color: ink
    )
    drawText(
        "↗",
        rect: NSRect(x: 880, y: 1210, width: 70, height: 70),
        font: font("Arial", 40),
        color: terracotta,
        alignment: .center
    )
    drawText(
        "欢迎私信  /  一起聊聊  /  一起创造",
        rect: NSRect(x: 92, y: 1445, width: 900, height: 54),
        font: font("STHeitiSC-Medium", 28, weight: .medium),
        color: white.withAlphaComponent(0.78),
        tracking: 2
    )
    fill(white.withAlphaComponent(0.24), NSRect(x: 88, y: 1540, width: 904, height: 2))
    drawText(
        "STILL TRYING — 2026",
        rect: NSRect(x: 92, y: 1570, width: 600, height: 34),
        font: font("Arial-BoldMT", 15, weight: .bold),
        color: white.withAlphaComponent(0.65),
        tracking: 3
    )
    drawSubtitle(
        "如果你也想一起做点什么，来找我。Let’s build together.",
        time: time,
        start: 34.0,
        end: 39.6
    )
}

func drawFrame(time: Double, context: CGContext, assets: Assets) {
    context.translateBy(x: 0, y: CGFloat(height))
    context.scaleBy(x: 1, y: -1)
    let graphics = NSGraphicsContext(cgContext: context, flipped: true)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = graphics
    context.setAllowsAntialiasing(true)
    context.interpolationQuality = .high

    if time < 4 {
        drawSceneOne(time)
    } else if time < 9 {
        drawSceneTwo(time, assets: assets)
    } else if time < 14 {
        drawSceneThree(time, assets: assets)
    } else if time < 22.2 {
        drawSceneFour(time, assets: assets)
    } else if time < 28.3 {
        drawSceneFive(time)
    } else if time < 34 {
        drawSceneSix(time)
    } else {
        drawSceneSeven(time)
    }

    NSGraphicsContext.restoreGraphicsState()
}

func savePreview(context: CGContext, path: String) {
    guard let image = context.makeImage() else { return }
    let bitmap = NSBitmapImageRep(cgImage: image)
    guard let png = bitmap.representation(using: .png, properties: [:]) else { return }
    try? png.write(to: URL(fileURLWithPath: path))
}

@main
struct Renderer {
    static func main() async throws {
        let root = CommandLine.arguments.count > 1
            ? CommandLine.arguments[1]
            : FileManager.default.currentDirectoryPath
        let base = "\(root)/deliverables/wechat-video"
        let screenshots = "\(base)/source/screenshots"

        let assets = try Assets(
            hero: loadImage("\(root)/public/hero-jessica.jpg"),
            portfolio: loadImage("\(screenshots)/portfolio-home.png"),
            arcade: loadImage("\(screenshots)/cat-arcade.png"),
            stand: loadImage("\(screenshots)/stand-up.png"),
            literature: loadImage("\(screenshots)/cat-literature.png")
        )

        let outputURL = URL(fileURLWithPath: "\(base)/output/jessica-intro-silent.mp4")
        let previewDirectory = "\(base)/output/previews"
        try FileManager.default.createDirectory(
            atPath: previewDirectory,
            withIntermediateDirectories: true
        )
        try? FileManager.default.removeItem(at: outputURL)

        let writer = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 6_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
            ],
        ]
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        input.expectsMediaDataInRealTime = false

        let attributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
        ]
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: input,
            sourcePixelBufferAttributes: attributes
        )

        guard writer.canAdd(input) else { throw RenderError.cannotCreateWriter }
        writer.add(input)
        guard writer.startWriting() else {
            throw RenderError.writerFailed(writer.error?.localizedDescription ?? "Unknown writer error")
        }
        writer.startSession(atSourceTime: .zero)

        let totalFrames = Int(duration * Double(fps))
        let previewFrames: [Int: String] = [
            Int(1.5 * Double(fps)): "01-slogan.png",
            Int(5.8 * Double(fps)): "02-jessica.png",
            Int(11.2 * Double(fps)): "03-portfolio.png",
            Int(15.2 * Double(fps)): "04-cat-arcade.png",
            Int(17.8 * Double(fps)): "05-stand-up.png",
            Int(20.5 * Double(fps)): "06-cat-literature.png",
            Int(24.8 * Double(fps)): "07-process.png",
            Int(30.6 * Double(fps)): "08-learning.png",
            Int(36.5 * Double(fps)): "09-collaboration.png",
        ]

        for frameIndex in 0..<totalFrames {
            while !input.isReadyForMoreMediaData {
                try await Task.sleep(for: .milliseconds(2))
            }

            guard let pool = adaptor.pixelBufferPool else {
                throw RenderError.cannotCreatePixelBuffer
            }
            var optionalBuffer: CVPixelBuffer?
            CVPixelBufferPoolCreatePixelBuffer(nil, pool, &optionalBuffer)
            guard let pixelBuffer = optionalBuffer else {
                throw RenderError.cannotCreatePixelBuffer
            }

            CVPixelBufferLockBaseAddress(pixelBuffer, [])
            defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }
            guard
                let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer),
                let context = CGContext(
                    data: baseAddress,
                    width: width,
                    height: height,
                    bitsPerComponent: 8,
                    bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                    space: CGColorSpace(name: CGColorSpace.sRGB)!,
                    bitmapInfo: CGBitmapInfo.byteOrder32Little
                        .union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue))
                        .rawValue
                )
            else {
                throw RenderError.cannotCreateContext
            }

            let time = Double(frameIndex) / Double(fps)
            drawFrame(time: time, context: context, assets: assets)

            if let previewName = previewFrames[frameIndex] {
                savePreview(context: context, path: "\(previewDirectory)/\(previewName)")
            }

            let presentationTime = CMTime(value: Int64(frameIndex), timescale: fps)
            guard adaptor.append(pixelBuffer, withPresentationTime: presentationTime) else {
                throw RenderError.appendFailed
            }

            if frameIndex % Int(fps * 5) == 0 {
                print("Rendered \(frameIndex / Int(fps))s / \(Int(duration))s")
            }
        }

        input.markAsFinished()
        await withCheckedContinuation { continuation in
            writer.finishWriting {
                continuation.resume()
            }
        }

        guard writer.status == .completed else {
            throw RenderError.writerFailed(writer.error?.localizedDescription ?? "Unknown writer error")
        }
        print(outputURL.path)
    }
}
