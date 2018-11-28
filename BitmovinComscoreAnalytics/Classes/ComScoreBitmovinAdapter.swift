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
        comscore.stop()
    }

    func onPaused(_ event: PausedEvent) {
        comscore.stop()
    }

    func onPlay(_ event: PlayEvent) {
        NSLog("Sending Play Video Content")
        comscore.playVideoContentPart(withMetadata: dictionary, andMediaType: comScoreContentType)
    }

    func onSourceUnloaded(_ event: SourceUnloadedEvent) {
        comscore.stop()
    }

    func onAdStarted(_ event: AdStartedEvent) {
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

        NSLog("Sending Play Video Advertisement")
        comscore.playVideoAdvertisement(withMetadata: adMetadata, andMediaType: comScoreAdType)
    }

    func onAdFinished(_ event: AdFinishedEvent) {
        comscore.stop()
        NSLog("Sending Play Video Content")
        comscore.playVideoContentPart(withMetadata: dictionary, andMediaType: comScoreContentType)
    }

    func onAdBreakStarted(_ event: AdBreakStartedEvent) {
        NSLog("On Ad Break Started")

    }

    func onAdBreakFinished(_ event: AdBreakFinishedEvent) {
        NSLog("On Ad Break Finished")
    }
}
