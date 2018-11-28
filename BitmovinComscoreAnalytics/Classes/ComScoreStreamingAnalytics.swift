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

    public init(bitmovinPlayer: BitmovinPlayer, metadata: ComScoreMetadata) {
        self.comScoreAdapter = ComScoreBitmovinAdapter.init(player: bitmovinPlayer, metadata: metadata)
    }

    public func update(metadata: ComScoreMetadata) {
        comScoreAdapter.update(metadata: metadata)
    }

}
