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
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
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

    @objc func applicationWillResignActive() {
        stop()
    }

    @objc func applicationWillBecomeActive() {
        resume()
    }
}

extension ComScoreBitmovinAdapter: PlayerListener {
    func onPlaybackFinished(_ event: PlaybackFinishedEvent) {
        NSLog("[ComScoreAnalytics] Stopping due to playback finished event")
        stop()
    }

    func onPaused(_ event: PausedEvent) {
        // ComScore only wants us to call stop if we are NOT in an ad break
        if !player.isAd {
            stop()
        }
    }

    func onPlay(_ event: PlayEvent) {
        // ComScore only wants us to resume into video content. We should not transition state when pause / play is called in an ad
        resume()
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
    
    private func resume(){
        if player.isAd {
            playAdContentPart(duration: currentAdDuration, timeOffset: currentAdOffset)
        }else {
            playVideoContentPart()
        }
    }

    private func stop() {
        self.accessQueue.sync {
            if state != .stopped {
                NSLog("[ComScoreAnalytics] Stopping")
                state = .stopped
                comScore.stop()
            }
        }
    }

    private func playVideoContentPart() {
        self.accessQueue.sync {
            if state != .video {
                NSLog("[ComScoreAnalytics] Stopping due to Video starting")
                stop()
                state = .video
                NSLog("[ComScoreAnalytics] Sending Play Video Content")
                comScore.playVideoContentPart(withMetadata: dictionary, andMediaType: comScoreContentType)
            }
        }
    }

    private func playAdContentPart(duration: TimeInterval, timeOffset: TimeInterval) {
        // This occurs on session start when Play is fired before AdStarted. Just return here as we will enter the ad once the AdStarted event is fired
        if duration == 0 {
            return
        }

        self.accessQueue.sync {
            if state != .advertisement {
                NSLog("[ComScoreAnalytics] Stopping due to Ad Started Event")
                stop()
                state = .advertisement
                let assetLength: Int = Int(duration * 1000)
                let adMetadata = ["ns_st_cl": "\(assetLength)"]

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
