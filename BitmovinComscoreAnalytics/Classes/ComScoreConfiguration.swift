//
//  ComscoreConfiguration.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/26/18.
//

import Foundation

public class ComScoreConfiguration {
    public let publisherId: String
    public let publisherSecret: String
    public let applicationName: String

    // MARK: - initializer
    /**
     Initialize a new ComSoreConfiguration with your application specific information
     
     - Parameters:
     - publisherId: Publisher ID assigned by ComScore
     - publisherSecret: Publisher Secret assigned by ComScore
     - applicationName: The name of your application that will be used for ComScore tracking     
     */
    public init(publisherId: String, publisherSecret: String, applicationName: String) {
        self.publisherId = publisherId
        self.publisherSecret = publisherSecret
        self.applicationName = applicationName
    }
}
