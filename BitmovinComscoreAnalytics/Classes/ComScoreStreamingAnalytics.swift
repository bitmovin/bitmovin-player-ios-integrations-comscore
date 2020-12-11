//
//  ComscoreStreamingAnalytics.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/26/18.
//

import Foundation
import BitmovinPlayer

public class ComScoreStreamingAnalytics {
    let adapter: ComScoreBitmovinAdapter

    // MARK: - initializer
    /**
     Initialize a ComScoreStreamingAnalytics
     
     - Parameters:
     - player: BitmovinPlayer instance to track
     - metadata: ComScore metadata associated with the content you are tracking
     */
    init(bitmovinPlayer: Player, configuration: ComScoreConfiguration, metadata: ComScoreMetadata, suppressAdAnalytics: Bool = true) {
        adapter = ComScoreBitmovinAdapter(
            player: bitmovinPlayer,
            configuration: configuration,
            metadata: metadata,
            suppressAdAnalytics: suppressAdAnalytics
        )
    }

    deinit {
        adapter.destroy()
    }

    /**
     Destroy ComScoreStreamingAnalytics and unregister it from player
     */
    public func destroy() {
        adapter.destroy()
    }

    /**
     Update metadata for tracked source. This should be called when changing sources.
     */
    public func update(metadata: ComScoreMetadata) {
        adapter.update(metadata: metadata)
    }

    /**
     Set a persistent label on the ComScore PublisherConfiguration
     - Parameters:
     - label: The label name
     - value: The label value
     */
    public func setPersistentLabel(label: String, value: String) {
        adapter.setPersistentLabel(label: label, value: value)
    }

    /**
     Set persistent labels on the ComScore PublisherConfiguration
     - Parameters:
     - label: The labels to set
     */
    public func setPersistentLabels(labels: [String: String]) {
        adapter.setPersistentLabels(labels: labels)
    }
    
    /**
     Enable/disable comscore ad content tracking
     - Parameters:
     - suppress: The enable/disable flag
     */
    public func suppressAdAnalytics(suppress: Bool) {
        adapter.suppressAdAnalytics = suppress
    }
}
