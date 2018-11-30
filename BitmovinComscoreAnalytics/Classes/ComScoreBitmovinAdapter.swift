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
    let comscore: SCORReducedRequirementsStreamingAnalytics = SCORReducedRequirementsStreamingAnalytics()
    let player: BitmovinPlayer
    var comScoreAdType: SCORAdType?
    var comScoreContentType: SCORContentType
    var internalDictionary: [String: Any] = [:]
    var state: ComScoreState = .stopped
    private let accessQueue = DispatchQueue(label: "ComScoreQueue", attributes: .concurrent)

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
        self.comScoreContentType = metadata.mediaType.toComscore()
        super.init()
        self.player.add(listener: self)
        self.dictionary = metadata.dictionary()
    }

    func update(metadata: ComScoreMetadata) {
        self.dictionary = metadata.dictionary()
        self.comScoreContentType = metadata.mediaType.toComscore()
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
        playVideoContentPart()
    }

    func onSourceUnloaded(_ event: SourceUnloadedEvent) {
        stop()
    }

    func onAdStarted(_ event: AdStartedEvent) {
        playAdContentPart(duration: event.duration, timeOffset: event.timeOffset)
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

    func stop() {
        self.accessQueue.sync {
            if state != .stopped {
                state = .stopped
                comscore.stop()
            }
        }
    }

    func playVideoContentPart() {
        self.accessQueue.sync {
            if state != .video {
                state = .video
                NSLog("[ComScoreAnalytics] Stopping due to Video starting")
                stop()
                NSLog("[ComScoreAnalytics] Sending Play Video Content")
                comscore.playVideoContentPart(withMetadata: dictionary, andMediaType: comScoreContentType)
            }
        }
    }

    func playAdContentPart(duration: TimeInterval, timeOffset: TimeInterval) {
        self.accessQueue.sync {
            if state != .advertisement {
                NSLog("[ComScoreAnalytics] Stopping due to Ad Started Event")
                stop()
                state = .advertisement
                let assetLength = duration * 1000
                let adMetadata = ["ns_st_cl": String(assetLength)]

                //This is wrong, but we dont have AdBreak time information
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

                guard let comScoreAdType = comScoreAdType else {
                    return
                }
                NSLog("[ComScoreAnalytics] Sending Play Ad")
                comscore.playVideoAdvertisement(withMetadata: adMetadata, andMediaType: comScoreAdType)
            }
        }
    }
}
