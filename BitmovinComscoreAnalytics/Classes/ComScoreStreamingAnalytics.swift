//
//  ComscoreStreamingAnalytics.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/26/18.
//

import Foundation
import BitmovinPlayer

public class ComScoreStreamingAnalytics {
    let comScoreAdapter: ComScoreBitmovinAdapter

    // MARK: - initializer
    /**
     Initializes a new Bitmovin ComScore Streaming Analytics object
     
     - Parameters:
     - player: BitmovinPlayer instance to track
     - metadata: ComScore metadata associated with the content you are tracking
     */
    init(bitmovinPlayer: BitmovinPlayer, configuration: ComScoreConfiguration, metadata: ComScoreMetadata) {
        self.comScoreAdapter = ComScoreBitmovinAdapter(player: bitmovinPlayer, configuration: configuration, metadata: metadata)
    }

    deinit {
        self.comScoreAdapter.destroy()
    }

    /**
     Destroys the ComScoreStreaming analytics object and unregisters it from the player
    */
    public func destroy() {
        self.comScoreAdapter.destroy()
    }

    /**
     Updates the metadata that is being tracked. Use this method when switching assets. Update metadata after unloading the old content and before loading the new content 
     */
    public func update(metadata: ComScoreMetadata) {
        comScoreAdapter.update(metadata: metadata)
    }
    
    /**
     Sets the user consent value to granted
    */
    public func userConsentGranted() {
        comScoreAdapter.userConsentGranted()
    }
    
    /**
     Sets the user consent value to denied
    */
    public func userConsentDenied() {
        comScoreAdapter.userConsentDenied()
    }
}
