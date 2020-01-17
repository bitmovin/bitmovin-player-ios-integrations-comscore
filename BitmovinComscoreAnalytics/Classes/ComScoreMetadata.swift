//
//  ComscoreMetadata.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/26/18.
//

import Foundation
/**
 Metadata object describing the content that is being played back
 */
@frozen
public struct ComScoreMetadata {
    let mediaType: ComScoreMediaType
    let uniqueContentId: String?
    let publisherBrandName: String?
    let programTitle: String?
    let programId: String?
    let episodeTitle: String?
    let episodeId: String?
    let episodeSeasonNumber: String?
    let episodeNumber: String?
    let contentGenre: String?
    let advertisementLoad: Bool?
    let digitalAirdate: String?
    let tvAirdate: String?
    let stationTitle: String?
    //swiftlint:disable identifier_name
    let c3: String?
    let c4: String?
    let c6: String?
    //swiftlint:enable identifier_name
    let completeEpisode: Bool?
    let feedType: String?
    //swiftlint:disable identifier_name

    // MARK: - initializer
    /**
     Initialize a new ComScoreMetadata object
     */
    public init(mediaType: ComScoreMediaType,
                uniqueContentId: String? = nil,
                publisherBrandName: String? = nil,
                programTitle: String? = nil,
                programId: String? = nil,
                episodeTitle: String? = nil,
                episodeId: String? = nil,
                episodeSeasonNumber: String? = nil,
                episodeNumber: String? = nil,
                contentGenre: String? = nil,
                advertisementLoad: Bool? = nil,
                digitalAirdate: String? = nil,
                tvAirdate: String? = nil,
                stationTitle: String? = nil,
                c3: String? = nil,
                c4: String? = nil,
                c6: String? = nil,
                completeEpisode: Bool? = nil,
                feedType: String? = nil) {
        self.mediaType = mediaType
        self.uniqueContentId = uniqueContentId
        self.publisherBrandName = publisherBrandName
        self.programTitle = programTitle
        self.programId = programId
        self.episodeTitle = episodeTitle
        self.episodeId = episodeId
        self.episodeSeasonNumber = episodeSeasonNumber
        self.episodeNumber = episodeNumber
        self.contentGenre = contentGenre
        self.advertisementLoad = advertisementLoad
        self.digitalAirdate = digitalAirdate
        self.tvAirdate = tvAirdate
        self.stationTitle = stationTitle
        self.c3 = c3
        self.c4 = c4
        self.c6 = c6
        self.completeEpisode = completeEpisode
        self.feedType = feedType
    }
    //swiftlint:enable identifier_name

    //swiftlint:disable cyclomatic_complexity
    func buildComScoreMetadataDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]

        if let uniqueContentId = self.uniqueContentId {
            dictionary["ns_st_ci"] = uniqueContentId
        }

        if let publisherBrandName = self.publisherBrandName {
            dictionary["ns_st_pu"] = publisherBrandName
        }

        if let programTitle = self.programTitle {
            dictionary["ns_st_pr"] = programTitle
        }

        if let programId = self.programId {
            dictionary["ns_st_tpr"] = programId
        }

        if let episodeTitle = self.episodeTitle {
            dictionary["ns_st_ep"] = episodeTitle
        }

        if let episodeId = self.episodeId {
            dictionary["ns_st_tep"] = episodeId
        }

        if let episodeSeasonNumber = self.episodeSeasonNumber {
            dictionary["ns_st_sn"] = episodeSeasonNumber
        }

        if let episodeNumber = self.episodeNumber {
            dictionary["ns_st_en"] = episodeNumber
        }

        if let contentGenre = self.contentGenre {
            dictionary["ns_st_ge"] = contentGenre
        }

        if advertisementLoad ?? false {
            dictionary["ns_st_ia"] = "1"
        }

        if let digitalAirdate = self.digitalAirdate {
            dictionary["ns_st_ddt"] = digitalAirdate
        }

        if let tvAirdate = self.tvAirdate {
            dictionary["ns_st_tdt"] = tvAirdate
        }

        if let stationTitle = self.stationTitle {
            dictionary["ns_st_st"] = stationTitle
        }

        //swiftlint:disable identifier_name
        if let c3 = self.c3 {
            dictionary["c3"] = c3
        }

        if let c4 = self.c4 {
            dictionary["c4"] = c4
        }

        if let c6 = self.c6 {
            dictionary["c6"] = c6
        }
        //swiftlint:enable identifier_name

        if completeEpisode ?? false {
            dictionary["ns_st_ce"] = "1"
        }

        if let feedType = self.feedType {
            dictionary["ns_st_ft"] = feedType
        }

        return dictionary
    }
    //swiftlint:enable cyclomatic_complexity

}
