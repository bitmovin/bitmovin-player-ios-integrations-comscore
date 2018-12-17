//
//  ComscoreBitmovinAdapter.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/26/18.
//

import Foundation
import ComScore
import BitmovinPlayer

enum ComScoreState {
    case video
    case advertisement
    case stopped
}

class ComScoreBitmovinAdapter: NSObject {
    private let comScore: SCORReducedRequirementsStreamingAnalytics = SCORReducedRequirementsStreamingAnalytics()
    private let player: BitmovinPlayer
    private var comScoreContentType: SCORContentType
    private var internalDictionary: [String: Any] = [:]
    private var state: ComScoreState = .stopped
    private let accessQueue = DispatchQueue(label: "ComScoreQueue", attributes: .concurrent)
    private var currentAdDuration: TimeInterval = 0
    private var currentAdOffset: TimeInterval = 0

    var dictionary: [String: Any] {
        get {
            let length = assetLength()
            internalDictionary["ns_st_cl"] = length * 1000
            return internalDictionary
        }
        set (dictionary) {
            self.internalDictionary = dictionary
        }
    }

    init(player: BitmovinPlayer, metadata: ComScoreMetadata) {
        self.player = player
        self.comScoreContentType = metadata.mediaType.toComScore()
        super.init()
        self.player.add(listener: self)
        self.dictionary = metadata.buildComScoreMetadataDictionary()
    }

    func update(metadata: ComScoreMetadata) {
        self.dictionary = metadata.buildComScoreMetadataDictionary()
        self.comScoreContentType = metadata.mediaType.toComScore()
    }

    func assetLength() -> TimeInterval {
        var assetLength = player.duration * 1000
        if assetLength == TimeInterval.infinity {
            assetLength = 0
        }
        return assetLength
    }
}

extension ComScoreBitmovinAdapter: PlayerListener {
    func onPlaybackFinished(_ event: PlaybackFinishedEvent) {
        NSLog("[ComScoreAnalytics] Stopping due to playback finished event")
        stop()
    }

    func onPaused(_ event: PausedEvent) {
        stop()
    }

    func onPlay(_ event: PlayEvent) {
        if player.isAd {
            playAdContentPart(duration: currentAdDuration, timeOffset: currentAdOffset)
        } else {
            playVideoContentPart()
        }
    }

    func onSourceUnloaded(_ event: SourceUnloadedEvent) {
        stop()
    }

    func onAdStarted(_ event: AdStartedEvent) {
        currentAdDuration = event.duration
        currentAdOffset = event.timeOffset
        playAdContentPart(duration: currentAdDuration, timeOffset: currentAdOffset)
    }

    func onAdFinished(_ event: AdFinishedEvent) {
        playVideoContentPart()
    }

    func onAdBreakStarted(_ event: AdBreakStartedEvent) {
        NSLog("[ComScoreAnalytics] On Ad Break Started")
    }

    func onAdBreakFinished(_ event: AdBreakFinishedEvent) {
        NSLog("[ComScoreAnalytics] On Ad Break Finished")
    }

    private func stop() {
        self.accessQueue.sync {
            if state != .stopped {
                state = .stopped
                comScore.stop()
            }
        }
    }

    private func playVideoContentPart() {
        self.accessQueue.sync {
            if state != .video {
                state = .video
                NSLog("[ComScoreAnalytics] Stopping due to Video starting")
                comScore.stop()
                NSLog("[ComScoreAnalytics] Sending Play Video Content")
                comScore.playVideoContentPart(withMetadata: dictionary, andMediaType: comScoreContentType)
            }
        }
    }

    private func playAdContentPart(duration: TimeInterval, timeOffset: TimeInterval) {
        self.accessQueue.sync {
            if state != .advertisement {
                NSLog("[ComScoreAnalytics] Stopping due to Ad Started Event")
                comScore.stop()
                state = .advertisement
                let assetLength = duration * 1000
                let adMetadata = ["ns_st_cl": String(assetLength)]

                var comScoreAdType: SCORAdType = .other

                //TODO, fix bug where we dont categorize multiple pre-rolls properly 
                if player.isLive {
                    comScoreAdType = .linearLive
                } else {
                    if timeOffset == 0 {
                        comScoreAdType = .linearOnDemandPreRoll
                    } else if timeOffset + duration == player.duration {
                        comScoreAdType = .linearOnDemandPostRoll
                    } else {
                        comScoreAdType = .linearOnDemandMidRoll
                    }
                }

                NSLog("[ComScoreAnalytics] Sending Play Ad")
                comScore.playVideoAdvertisement(withMetadata: adMetadata, andMediaType: comScoreAdType)
            }
        }
    }
}
