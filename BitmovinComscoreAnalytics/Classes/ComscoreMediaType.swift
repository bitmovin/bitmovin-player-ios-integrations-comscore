//
//  ComscoreMediaType.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/26/18.
//

import Foundation
import ComScore

/**
 ComScoreMediaType associated with the content you have loaded into the BitmovinPlayer
 */
@frozen
public enum ComScoreMediaType: String {
    case longFormOnDemand
    case shortFormOnDemand
    case live
    case userGeneratedLongFormOnDemand
    case userGeneratedShortFormOnDemand
    case userGeneratedLive
    case bumper
    case other

    func toComScore() -> SCORContentType {
        switch self {
        case .longFormOnDemand:
            return .longFormOnDemand
        case .shortFormOnDemand:
            return .shortFormOnDemand
        case .live:
            return .live
        case .userGeneratedLongFormOnDemand:
            return .userGeneratedLongFormOnDemand
        case .userGeneratedShortFormOnDemand:
            return .userGeneratedShortFormOnDemand
        case .userGeneratedLive:
            return .userGeneratedLive
        case .bumper:
            return .bumper
        case .other:
            return .other
        }
    }
}
