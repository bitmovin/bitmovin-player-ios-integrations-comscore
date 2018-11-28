//
//  ComScoreMetadataBuilder.swift
//  BitmovinComScoreAnalytics
//
//  Created by Cory Zachman on 11/27/18.
//

import Foundation

public class ComScoreMetadataBuilder {
    var mediaType: ComScoreMediaType
    var uniqueContentId: String?
    var publisherBrandName: String?
    var programTitle: String?
    var programId: String?
    var episodeTitle: String?
    var episodeId: String?
    var episodeSeasonNumber: String?
    var episodeNumber: String?
    var contentGenre: String?
    var advertisementLoad: Bool = false
    var digitalAirdate: String?
    var tvAirdate: String?
    var stationTitle: String?
    //swiftlint:disable identifier_name
    var c3: String?
    var c4: String?
    var c6: String?
    //swiftlint:enable identifier_name
    var completeEpisode: Bool = false
    var feedType: String?

    public init(mediaType: ComScoreMediaType) {
        self.mediaType = mediaType
    }

    public func with(mediaType: ComScoreMediaType) -> ComScoreMetadataBuilder {
        self.mediaType = mediaType
        return self
    }

    public func with(uniqueContentId: String) -> ComScoreMetadataBuilder {
        self.uniqueContentId = uniqueContentId
        return self
    }

    public func with(publisherBrandName: String) -> ComScoreMetadataBuilder {
        self.publisherBrandName = publisherBrandName
        return self
    }

    public func with(programTitle: String) -> ComScoreMetadataBuilder {
        self.programTitle = programTitle
        return self
    }

    public func with(programId: String) -> ComScoreMetadataBuilder {
        self.programId = programId
        return self
    }

    public func with(episodeTitle: String) -> ComScoreMetadataBuilder {
        self.episodeTitle = episodeTitle
        return self
    }

    public func with(episodeId: String) -> ComScoreMetadataBuilder {
        self.episodeId = episodeId
        return self
    }

    public func with(episodeSeasonNumber: String) -> ComScoreMetadataBuilder {
        self.episodeSeasonNumber = episodeSeasonNumber
        return self
    }

    public func with(episodeNumber: String) -> ComScoreMetadataBuilder {
        self.episodeNumber = episodeNumber
        return self
    }

    public func with(contentGenre: String) -> ComScoreMetadataBuilder {
        self.contentGenre = contentGenre
        return self
    }

    public func with(advertisementLoad: Bool) -> ComScoreMetadataBuilder {
        self.advertisementLoad = advertisementLoad
        return self
    }

    public func with(digitalAirdate: String) -> ComScoreMetadataBuilder {
        self.digitalAirdate = digitalAirdate
        return self
    }

    public func with(tvAirdate: String) -> ComScoreMetadataBuilder {
        self.tvAirdate = tvAirdate
        return self
    }

    public func with(stationTitle: String) -> ComScoreMetadataBuilder {
        self.stationTitle = stationTitle
        return self
    }

    //swiftlint:disable identifier_name
    public func with(c3: String) -> ComScoreMetadataBuilder {
        self.c3 = c3
        return self
    }

    public func with(c4: String) -> ComScoreMetadataBuilder {
        self.c4 = c4
        return self
    }

    public func with(c6: String) -> ComScoreMetadataBuilder {
        self.c6 = c6
        return self
    }
    //swiftlint:enable identifier_name

    public func with(completeEpisode: Bool) -> ComScoreMetadataBuilder {
        self.completeEpisode = completeEpisode
        return self
    }

    public func with(feedType: String) -> ComScoreMetadataBuilder {
        self.feedType = feedType
        return self
    }

    public func build() -> ComScoreMetadata {

        //swiftlint:disable line_length
        return ComScoreMetadata(mediaType: mediaType, uniqueContentId: uniqueContentId, publisherBrandName: publisherBrandName, programTitle: programTitle, programId: programId, episodeTitle: episodeTitle, episodeId: episodeId, episodeSeasonNumber: episodeSeasonNumber, episodeNumber: episodeNumber, contentGenre: contentGenre, advertisementLoad: advertisementLoad, digitalAirdate: digitalAirdate, tvAirdate: tvAirdate, stationTitle: stationTitle, c3: c3, c4: c4, c6: c6, completeEpisode: completeEpisode, feedType: feedType)
        //siwftlint:enable line_length
    }

}
