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
    var bitmovinPlayer: BitmovinPlayer?
    @IBOutlet var playerView: UIView!
    @IBOutlet var unloadButton: UIButton!
    @IBOutlet var liveButton: UIButton!
    @IBOutlet var vodButton: UIButton!
    @IBOutlet var reloadButton: UIButton!
    var comScoreStreamingAnalytics:ComScoreStreamingAnalytics?
    
    var bitmovinPlayerView: PlayerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        createPlayer()
    }
    
    func createPlayer() {
        // Create a Player Configuration
        let configuration = PlayerConfiguration()
        configuration.playbackConfiguration.isAutoplayEnabled = true
        
        //Create a BitmovinYospacePlayer
        bitmovinPlayer = BitmovinPlayer(configuration: configuration)
        
        guard let player = bitmovinPlayer else {
            return
        }
                
        self.playerView.backgroundColor = .black
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unloadButtonClicked(sender: UIButton) {
        self.bitmovinPlayer?.unload()
    }
    
    @IBAction func reloadButtonClicked(sender: UIButton) {
        self.bitmovinPlayer?.unload()
    }
    
    @IBAction func vodButtonClicked(sender: UIButton) {
        guard let streamUrl = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8") else {
            return
        }
        
        // Create a Comscore Configuration
        let comScoreMetadata:ComScoreMetadata = ComScoreMetadata(mediaType: .longFormOnDemand,publisherBrandName: "ABC",programTitle: "Modern Family", episodeTitle: "Rash Decisions", episodeSeasonNumber: "1", episodeNumber: "2", contentGenre: "Comedy", stationTitle: "Hulu",completeEpisode: true)
       
        if let bitmovinPlayer = bitmovinPlayer {
            comScoreStreamingAnalytics = ComScoreStreamingAnalytics(bitmovinPlayer: bitmovinPlayer, metadata: comScoreMetadata)
        }
        
        let sourceConfig = SourceConfiguration()
        sourceConfig.addSourceItem(item: SourceItem(hlsSource: HLSSource(url: streamUrl)))
        bitmovinPlayer?.load(sourceConfiguration: sourceConfig)
    }
    
    @IBAction func liveButtonClicked(sender: UIButton) {
        guard let streamUrl = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8") else {
            return
        }
        
        // Create a Comscore Configuration
        let comScoreMetadata:ComScoreMetadata = ComScoreMetadata(mediaType: .longFormOnDemand,publisherBrandName: "ABC",programTitle: "Modern Family", episodeTitle: "Rash Decisions", episodeSeasonNumber: "1", episodeNumber: "2", contentGenre: "Comedy", stationTitle: "Hulu",completeEpisode: true)
        
        if let bitmovinPlayer = bitmovinPlayer {
            comScoreStreamingAnalytics = ComScoreStreamingAnalytics(bitmovinPlayer: bitmovinPlayer, metadata: comScoreMetadata)
        }
        
        let sourceConfig = SourceConfiguration()
        sourceConfig.addSourceItem(item: SourceItem(hlsSource: HLSSource(url: streamUrl)))
        bitmovinPlayer?.load(sourceConfiguration: sourceConfig)
    }

}

