//
//  ViewController.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/25/2018.
//  Copyright (c) 2018 Cory Zachman. All rights reserved.
//

import UIKit
import BitmovinComScoreAnalytics
import BitmovinPlayer

class ViewController: UIViewController {
    let adTagVastSkippable = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
    let adTagVast1 = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="
    let adTagVast2 = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/32573358/2nd_test_ad_unit&ciu_szs=300x100&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&url=[referrer_url]&description_url=[description_url]&correlator="

    var bitmovinPlayer: Player?
    @IBOutlet var playerView: UIView!

    var comScoreStreamingAnalytics: ComScoreStreamingAnalytics?

    var bitmovinPlayerView: PlayerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        createPlayer()
    }

    func createPlayer() {
        // Create player configuration
        let config = PlayerConfiguration()
        config.playbackConfiguration.isAutoplayEnabled = true

        // Create Advertising configuration
        let adSource1 = AdSource(tag: urlWithCorrelator(adTag: adTagVastSkippable), ofType: .IMA)
        let adSource2 = AdSource(tag: urlWithCorrelator(adTag: adTagVast1), ofType: .IMA)
        let adSource3 = AdSource(tag: urlWithCorrelator(adTag: adTagVast2), ofType: .IMA)

        let preRoll = AdItem(adSources: [adSource1], atPosition: "pre")
        let midRoll = AdItem(adSources: [adSource2], atPosition: "20%")
        let postRoll = AdItem(adSources: [adSource3], atPosition: "post")

        let adConfig = AdvertisingConfiguration(schedule: [preRoll, midRoll, postRoll])
        config.advertisingConfiguration = adConfig

        // Create player based on player configuration
        let player = Player(configuration: config)
        self.bitmovinPlayer = player

        if bitmovinPlayerView == nil {
            // Create player view and pass the player instance to it
            bitmovinPlayerView = BMPBitmovinPlayerView(player: player, frame: .zero)

            guard let view = bitmovinPlayerView else {
                return
            }

            // Size the player view
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.frame = playerView.bounds
            playerView.addSubview(view)
            playerView.bringSubviewToFront(view)

        } else {
            bitmovinPlayerView?.player = bitmovinPlayer
        }
    }

    func destroyPlayer() {
        bitmovinPlayer?.unload()
        bitmovinPlayer?.destroy()
        bitmovinPlayer = nil
    }

    func urlWithCorrelator(adTag: String) -> URL {
        return URL(string: String(format: "%@%d", adTag, Int(arc4random_uniform(100000))))!
    }

    @IBAction func unloadButtonClicked(sender: UIButton) {
        bitmovinPlayer?.unload()
    }

    @IBAction func vodButtonClicked(sender: UIButton) {
        guard let streamUrl = URL(string: "https://bitmovin-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8") else {
            return
        }

        // Create ComScoreMetadata
        let comScoreMetadata: ComScoreMetadata = ComScoreMetadata(
            mediaType: .longFormOnDemand,
            publisherBrandName: "ABC",
            programTitle: "Modern Family",
            episodeTitle: "Rash Decisions",
            episodeSeasonNumber: "1",
            episodeNumber: "2",
            contentGenre: "Comedy",
            stationTitle: "Hulu",
            completeEpisode: true
        )

        if let bitmovinPlayer = bitmovinPlayer {
            do {
                try comScoreStreamingAnalytics = ComScoreAnalytics.createComScoreStreamingAnalytics(
                    bitmovinPlayer: bitmovinPlayer,
                    metadata: comScoreMetadata
                )
            } catch {
                print("ComScoreAnalytics must be started before creating a ComScoreStreamingAnalytics object")
            }
        }

        let sourceConfig = SourceConfiguration()
        sourceConfig.addSourceItem(item: SourceItem(hlsSource: HLSSource(url: streamUrl)))
        bitmovinPlayer?.load(sourceConfiguration: sourceConfig)
    }
}
