//
//  ViewController.swift
//  BitmovinComScoreAnalytics_Example_tvOS
//
//  Created by Cory Zachman on 2/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import BitmovinComScoreAnalytics
import BitmovinPlayer
import ComScore

class ViewController: UIViewController {
    let adTagVastSkippable = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
    let adTagVast1 = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="
    let adTagVast2 = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/32573358/2nd_test_ad_unit&ciu_szs=300x100&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&url=[referrer_url]&description_url=[description_url]&correlator="
    
    var bitmovinPlayer: BitmovinPlayer?
    @IBOutlet var playerView: UIView!
    var comScoreStreamingAnalytics: ComScoreStreamingAnalytics?
    
    var bitmovinPlayerView: PlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPlayer()
    }
    
    func createPlayer() {
        self.view.backgroundColor = .black
        
        // Define needed resources
        guard let streamUrl = URL(string: "https://bitmovin-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8") else {
            return
        }
        
        // Create player configuration
        let config = PlayerConfiguration()
                
        do {
            try config.setSourceItem(url: streamUrl)
            
            // Create player based on player configuration
            let player = BitmovinPlayer(configuration: config)
            self.bitmovinPlayer = player
            
            // Create a Comscore Configuration
            let comScoreMetadata: ComScoreMetadata = ComScoreMetadata(mediaType: .longFormOnDemand, publisherBrandName: "ABC", programTitle: "Modern Family", episodeTitle: "Rash Decisions", episodeSeasonNumber: "1", episodeNumber: "2", contentGenre: "Comedy", stationTitle: "Hulu", completeEpisode: true)
            
            // Create a ComScore Streaming Analytics
            if let bitmovinPlayer = bitmovinPlayer {
                do {
                    try comScoreStreamingAnalytics = ComScoreAnalytics.createComScoreStreamingAnalytics(bitmovinPlayer: bitmovinPlayer, metadata: comScoreMetadata)
                } catch {
                    print("ComScoreAnalytics must be started before creating a ComScoreStreamingAnalytics object")
                }
            }
            
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
            
        } catch {
            print("Configuration error: \(error)")
        }
    }    
}
