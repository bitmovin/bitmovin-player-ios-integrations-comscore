//
//  ComscoreBitmovinAdapter.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/26/18.
//

import Foundation
import ComScore
import BitmovinPlayer

class ComScoreBitmovinAdapter: NSObject {
    let comscore: SCORReducedRequirementsStreamingAnalytics = SCORReducedRequirementsStreamingAnalytics()
    let player: BitmovinPlayer
    var comScoreAdType: SCORAdType?
    var comScoreContentType: SCORContentType
    var internalDictionary: [String: Any] = [:]
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
        comscore.stop()
    }

    func onPaused(_ event: PausedEvent) {
        NSLog("[ComScoreAnalytics] Stopping due to pause event")
        comscore.stop()
    }

    func onPlay(_ event: PlayEvent) {
        NSLog("[ComScoreAnalytics] Sending Play Video Content")
        comscore.playVideoContentPart(withMetadata: dictionary, andMediaType: comScoreContentType)
    }

    func onSourceUnloaded(_ event: SourceUnloadedEvent) {
        NSLog("[ComScoreAnalytics] Stopping due to source unloaded event")
        comscore.stop()
    }

    func onAdStarted(_ event: AdStartedEvent) {
        NSLog("[ComScoreAnalytics] Stopping due to Ad Started Event")

        comscore.stop()
        let assetLength = event.duration * 1000
        let adMetadata = ["ns_st_cl": String(assetLength)]

        //This is wrong, but we dont have AdBreak time information
        if player.isLive {
            comScoreAdType = .linearLive
        } else {
            if event.timeOffset == 0 {
                comScoreAdType = .linearOnDemandPreRoll
            } else if event.timeOffset + event.duration == player.duration {
                comScoreAdType = .linearOnDemandPostRoll
            } else {
                comScoreAdType = .linearOnDemandMidRoll
            }
        }

        guard let comScoreAdType = comScoreAdType else {
            return
        }

        NSLog("[ComScoreAnalytics] Sending Play Video Advertisement")
        comscore.playVideoAdvertisement(withMetadata: adMetadata, andMediaType: comScoreAdType)
    }

    func onAdFinished(_ event: AdFinishedEvent) {
        comscore.stop()
        NSLog("[ComScoreAnalytics] Sending Play Video Content")
        comscore.playVideoContentPart(withMetadata: dictionary, andMediaType: comScoreContentType)
    }

    func onAdBreakStarted(_ event: AdBreakStartedEvent) {
        NSLog("[ComScoreAnalytics] On Ad Break Started")

    }

    func onAdBreakFinished(_ event: AdBreakFinishedEvent) {
        NSLog("[ComScoreAnalytics] On Ad Break Finished")
    }
}
