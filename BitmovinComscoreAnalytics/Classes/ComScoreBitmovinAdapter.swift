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
    private let streamingAnalytics = SCORStreamingAnalytics()
    private let player: BitmovinPlayer
    private let configuration: ComScoreConfiguration
    private var contentType: SCORStreamingContentType
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

    init(player: BitmovinPlayer, configuration: ComScoreConfiguration, metadata: ComScoreMetadata) {
        self.player = player
        self.configuration = configuration
        self.contentType = metadata.mediaType.toComScore()
        super.init()
        self.player.add(listener: self)
        self.dictionary = metadata.buildComScoreMetadataDictionary()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillBecomeActive),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        BitLog.isEnabled = configuration.debug
    }

    deinit {
        destroy()
    }

    public func setPersistentLabel(label: String, value: String) {
        notifyHiddenEvent(publisherId: self.configuration.publisherId, label: label, value: value)
        BitLog.d("ComScore persistent label set: [\(label):\(value)]")
    }

    public func setPersistentLabels(labels: [String: String]) {
        notifyHiddenEvents(publisherId: self.configuration.publisherId, labels: labels)
        BitLog.d("ComScore persistent labels set: [\(labels.map { "\($0.key):\($0.value)"})]")
    }

    func update(metadata: ComScoreMetadata) {
        self.dictionary = metadata.buildComScoreMetadataDictionary()
        self.contentType = metadata.mediaType.toComScore()
    }

    func destroy() {
        self.player.remove(listener: self)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willResignActiveNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
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
        stop()
    }

    func onPaused(_ event: PausedEvent) {

        //TODO: remove once we have tvOS support for this method
        #if os(iOS)
        // ComScore only wants us to call stop if we are NOT in an ad break
        if !player.isAd {
            stop()
        }
        #else
        stop()
        #endif
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

    private func resume() {
        // TODO remove once we have iOS support
        #if os(iOS)
        if player.isAd {
            playAdContentPart(duration: currentAdDuration, timeOffset: currentAdOffset)
        } else {
            playVideoContentPart()
        }
        #else
        playVideoContentPart()
        #endif
    }

    private func stop() {
        self.accessQueue.sync {
            if state != .stopped {
                BitLog.d("Stopping ComScore tracking")
                state = .stopped
                streamingAnalytics.notifyPause()
            }
        }
    }

    private func playVideoContentPart() {
        self.accessQueue.sync {
            if state != .video {
                stop()
                state = .video
                let contentMetadata = SCORStreamingContentMetadata { builder in
                    builder?.setMediaType(self.contentType)
                    builder?.setCustomLabels(self.dictionary)
                }
                streamingAnalytics.setMetadata(contentMetadata)
                streamingAnalytics.notifyPlay()

                BitLog.d("Starting ComScore video content tracking")
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
                stop()
                state = .advertisement
                let assetLength: Int = Int(duration * 1000)

                var comScoreAdType: SCORStreamingAdvertisementType = .other

                //TODO, fix bug where we dont categorize multiple pre-rolls properly 
                if player.isLive {
                    comScoreAdType = .live
                } else {
                    if timeOffset == 0 {
                        comScoreAdType = .onDemandPreRoll
                    } else if timeOffset + duration == player.duration {
                        comScoreAdType = .onDemandPostRoll
                    } else {
                        comScoreAdType = .onDemandMidRoll
                    }
                }

                let advertMetadata = SCORStreamingAdvertisementMetadata { builder in
                    builder?.setMediaType(comScoreAdType)
                    builder?.setCustomLabels(
                        ["ns_st_cl": "\(assetLength)"]
                    )
                }
                streamingAnalytics.setMetadata(advertMetadata)
                streamingAnalytics.notifyPlay()

                BitLog.d("Starting ComScore ad play tracking")
            }
        }
    }
}
