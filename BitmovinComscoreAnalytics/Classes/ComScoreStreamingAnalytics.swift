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
     Initialize a ComScoreStreamingAnalytics
     
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
     Destroy ComScoreStreamingAnalytics and unregister it from player
     */
    public func destroy() {
        self.comScoreAdapter.destroy()
    }
    
    /**
     Update metadata for tracked source. This should be called when changing sources.
     */
    public func update(metadata: ComScoreMetadata) {
        comScoreAdapter.update(metadata: metadata)
    }
    
    /**
     Set user consent to ComScoreUserConsent.GRANTED
     */
    @available(*, deprecated, message: "Deprecated as of release 1.3.0")
    public func userConsentGranted() {
        comScoreAdapter.userConsentGranted()
    }
    
    /**
     Set user consent to ComScoreUserConsent.DENIED
     */
    @available(*, deprecated, message: "Deprecated as of release 1.3.0")
    public func userConsentDenied() {
        comScoreAdapter.userConsentDenied()
    }
    
    /**
     Set a persistent label on the ComScore PublisherConfiguration
     - Parameters:
     - label: The label to set
     */
    public func setPersistentLabel(label: (String, String)) {
        comScoreAdapter.setPersistentLabel(label: label)
    }
    
    /**
     Set persistent labels on the ComScore PublisherConfiguration
     - Parameters:
     - label: The labels to set
     */
    public func setPersistentLabels(labels: [String: String]) {
        comScoreAdapter.setPersistentLabels(labels: labels)
    }
}
