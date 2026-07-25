import AVFoundation
import Foundation

enum MuxError: Error {
    case missingTrack(String)
    case cannotCreateTrack
    case cannotCreateExporter
    case exportFailed(String)
}

@main
struct AudioMuxer {
    static func main() async throws {
        let root = CommandLine.arguments.count > 1
            ? CommandLine.arguments[1]
            : FileManager.default.currentDirectoryPath
        let base = "\(root)/deliverables/wechat-video"
        let silentURL = URL(fileURLWithPath: "\(base)/output/jessica-intro-silent.mp4")
        let narrationURL = URL(fileURLWithPath: "\(base)/source/narration.aiff")
        let musicURL = URL(fileURLWithPath: "\(base)/source/ambient-bed.wav")
        let outputURL = URL(fileURLWithPath: "\(base)/output/jessica-wechat-video.mp4")
        try? FileManager.default.removeItem(at: outputURL)

        let videoAsset = AVURLAsset(url: silentURL)
        let narrationAsset = AVURLAsset(url: narrationURL)
        let musicAsset = AVURLAsset(url: musicURL)
        let composition = AVMutableComposition()

        guard
            let sourceVideo = try await videoAsset.loadTracks(withMediaType: .video).first,
            let targetVideo = composition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: kCMPersistentTrackID_Invalid
            )
        else {
            throw MuxError.missingTrack("video")
        }

        let videoDuration = try await videoAsset.load(.duration)
        try targetVideo.insertTimeRange(
            CMTimeRange(start: .zero, duration: videoDuration),
            of: sourceVideo,
            at: .zero
        )
        targetVideo.preferredTransform = try await sourceVideo.load(.preferredTransform)

        guard
            let sourceNarration = try await narrationAsset.loadTracks(withMediaType: .audio).first,
            let targetNarration = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid
            )
        else {
            throw MuxError.missingTrack("narration")
        }
        let narrationDuration = try await narrationAsset.load(.duration)
        try targetNarration.insertTimeRange(
            CMTimeRange(start: .zero, duration: narrationDuration),
            of: sourceNarration,
            at: CMTime(seconds: 0.45, preferredTimescale: 600)
        )

        guard
            let sourceMusic = try await musicAsset.loadTracks(withMediaType: .audio).first,
            let targetMusic = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid
            )
        else {
            throw MuxError.missingTrack("music")
        }
        let musicDuration = min(try await musicAsset.load(.duration), videoDuration)
        try targetMusic.insertTimeRange(
            CMTimeRange(start: .zero, duration: musicDuration),
            of: sourceMusic,
            at: .zero
        )

        let narrationMix = AVMutableAudioMixInputParameters(track: targetNarration)
        narrationMix.setVolume(1.0, at: .zero)
        let musicMix = AVMutableAudioMixInputParameters(track: targetMusic)
        musicMix.setVolume(0.34, at: .zero)
        musicMix.setVolumeRamp(
            fromStartVolume: 0.34,
            toEndVolume: 0.0,
            timeRange: CMTimeRange(
                start: CMTime(seconds: 39.0, preferredTimescale: 600),
                duration: CMTime(seconds: 3.0, preferredTimescale: 600)
            )
        )
        let audioMix = AVMutableAudioMix()
        audioMix.inputParameters = [narrationMix, musicMix]

        guard let exporter = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality
        ) else {
            throw MuxError.cannotCreateExporter
        }
        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        exporter.audioMix = audioMix
        exporter.shouldOptimizeForNetworkUse = true

        do {
            try await exporter.export(to: outputURL, as: .mp4)
        } catch {
            throw MuxError.exportFailed(error.localizedDescription)
        }
        print(outputURL.path)
    }
}
