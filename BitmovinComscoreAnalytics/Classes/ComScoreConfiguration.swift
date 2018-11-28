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

    public init(publisherId: String, publisherSecret: String, applicationName: String) {
        self.publisherId = publisherId
        self.publisherSecret = publisherSecret
        self.applicationName = applicationName
    }
}
