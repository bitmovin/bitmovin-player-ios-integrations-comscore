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
     Sets the user consent to granted. Use after the ComScoreAnalytics object has been started
    */
    public static func userConsentGranted() {
        serialQueue.sync {
            if started {
                let publisherConfig = SCORAnalytics.configuration().publisherConfiguration(withPublisherId: ComScoreAnalytics.configuration!.publisherId)
                publisherConfig?.setPersistentLabelWithName("cs_ucfr", value: ComScoreUserConsent.granted.rawValue)
                SCORAnalytics.notifyHiddenEvent()
            }
        }
    }
    
    /**
     Sets the user consent to denied. Use after the ComScoreAnalytics object has been started
    */
    public static func userConsentDenied() {
        serialQueue.sync {
            if started {
                let publisherConfig = SCORAnalytics.configuration().publisherConfiguration(withPublisherId: ComScoreAnalytics.configuration!.publisherId)
                publisherConfig?.setPersistentLabelWithName("cs_ucfr", value: ComScoreUserConsent.denied.rawValue)
                SCORAnalytics.notifyHiddenEvent()
            }
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
