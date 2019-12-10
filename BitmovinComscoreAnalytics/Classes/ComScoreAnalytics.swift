import ComScore
import BitmovinPlayer

public final class ComScoreAnalytics {
    private static let serialQueue = DispatchQueue(label: "com.bitmovin.player.integrations.comscore.ComScoreAnalytics")
    private static var started: Bool = false
    private static var configuration: ComScoreConfiguration?

    /**
     Starts the ComScoreAnalytics monitoring. Must be called before creating a ComScoreStreamingAnalytics object
     - Parameters:
     - configuration: The ComScoreConfiguration that contains your application specific information
     */
    public static func start(configuration: ComScoreConfiguration) {
        serialQueue.sync {
            if !started {
                ComScoreAnalytics.configuration = configuration
                let builder = SCORPublisherConfigurationBuilder()
                builder.publisherId = configuration.publisherId
                builder.publisherSecret = configuration.publisherSecret
                builder.applicationName = configuration.applicationName
                if configuration.userConsent != .unknown {
                    builder.persistentLabels = ["cs_ucfr": configuration.userConsent.rawValue]
                }
                SCORAnalytics.configuration()?.addClient(with: builder.build())
                SCORAnalytics.start()
                started = true
            } else {
                NSLog("ComScoreAnalytics has already been started. Ignoring call to start")
            }
        }
    }
    
    /**
     Updates the user consent.
    - Parameters:
    - configuration: The ComScoreConfiguration that contains your application specific information
    */
    public static func updateUserConsent(configuration: ComScoreConfiguration) {
        serialQueue.sync {
            let publisherConfig = SCORAnalytics.configuration().publisherConfiguration(withPublisherId: configuration.publisherId)
            publisherConfig?.setPersistentLabelWithName("cs_ucfr", value: configuration.userConsent.rawValue)
            SCORAnalytics.notifyHiddenEvent()
        }
    }

    public static func createComScoreStreamingAnalytics(bitmovinPlayer: BitmovinPlayer, metadata: ComScoreMetadata) throws -> ComScoreStreamingAnalytics? {
        if started {
            return ComScoreStreamingAnalytics(bitmovinPlayer: bitmovinPlayer, configuration: ComScoreAnalytics.configuration!, metadata: metadata)
        } else {
            throw ComScoreError.notStarted
        }
    }

    public static func isActive() -> Bool {
        return ComScoreAnalytics.started
    }
}

public enum ComScoreError: Error {
    case notStarted
}
