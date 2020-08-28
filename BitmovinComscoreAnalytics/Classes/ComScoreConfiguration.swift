//
//  ComscoreConfiguration.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/26/18.
//

import Foundation

public class ComScoreConfiguration {
    public let publisherId: String
    public let applicationName: String
    public var userConsent: ComScoreUserConsent
    public let enableChildDirectedApplicationMode: Bool
    public var debug: Bool

    // MARK: - initializer
    /**
     Initializes a new ComSoreConfiguration with application specific information
     
     - Parameters:
     - publisherId: Publisher id assigned by ComScore
     - applicationName: Application name used for ComScore tracking
     - userConsent: User consent for ComScore data collection
     - enableChildDirectedApplicationMode: Controls collection of advertising id within the app
     - debug: Debug mode
     */
    public init(publisherId: String, applicationName: String, userConsent: ComScoreUserConsent = .unknown, enableChildDirectedApplicationMode: Bool = false, debug: Bool = false) {
        self.publisherId = publisherId
        self.applicationName = applicationName
        self.userConsent = userConsent
        self.enableChildDirectedApplicationMode = enableChildDirectedApplicationMode
        self.debug = debug
    }
}
