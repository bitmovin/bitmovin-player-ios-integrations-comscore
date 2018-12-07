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
    public init(bitmovinPlayer: BitmovinPlayer, metadata: ComScoreMetadata) {
        self.comScoreAdapter = ComScoreBitmovinAdapter(player: bitmovinPlayer, metadata: metadata)
    }

    /**
     Updates the metadata that is being tracked. Use this method when switching assets. Update metadata after unloading the old content and before loading the new content 
     */
    public func update(metadata: ComScoreMetadata) {
        comScoreAdapter.update(metadata: metadata)
    }

}
