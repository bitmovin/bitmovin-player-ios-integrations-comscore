import ComScore
import BitmovinPlayer

public final class ComScoreAnalytics {
    private static let serialQueue = DispatchQueue(label: "com.bitmovin.player.integrations.comscore.ComScoreAnalytics")
    private static var started: Bool = false
    private static var configuration: ComScoreConfiguration?
    
    /**
     Start ComScoreAnalytics app level tracking
     - Parameters:
     - configuration: The ComScoreConfiguration that contains application specific information
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
     Set user consent to ComScoreUserConsent.GRANTED
     */
    @available(*, deprecated, message: "Deprecated as of release 1.3.0")
    public static func userConsentGranted() {
        serialQueue.sync {
            if started {
                let publisherConfig = SCORAnalytics.configuration().publisherConfiguration(withPublisherId: ComScoreAnalytics.configuration?.publisherId)
                publisherConfig?.setPersistentLabelWithName("cs_ucfr", value: ComScoreUserConsent.granted.rawValue)
                SCORAnalytics.notifyHiddenEvent()
            }
        }
    }
    
    /**
     Set user consent to ComScoreUserConsent.DENIED
     */
    @available(*, deprecated, message: "Deprecated as of release 1.3.0")
    public static func userConsentDenied() {
        serialQueue.sync {
            if started {
                let publisherConfig = SCORAnalytics.configuration().publisherConfiguration(withPublisherId: ComScoreAnalytics.configuration?.publisherId)
                publisherConfig?.setPersistentLabelWithName("cs_ucfr", value: ComScoreUserConsent.denied.rawValue)
                SCORAnalytics.notifyHiddenEvent()
            }
        }
    }
    
    /**
     Set a persistent label on the ComScore PublisherConfiguration
     - Parameters:
     - label: The label to set
     */
    public static func setPersistentLabel(label: (String, String)) {
        serialQueue.sync {
            if started {
                let publisherConfig = SCORAnalytics.configuration().publisherConfiguration(withPublisherId: ComScoreAnalytics.configuration?.publisherId)
                publisherConfig?.setPersistentLabelWithName(label.0, value: label.1)
                SCORAnalytics.notifyHiddenEvent()
            }
        }
    }
    
    /**
     Set persistent labels on the ComScore PublisherConfiguration
     - Parameters:
     - label: The labels to set
     */
    public static func setPersistentLabels(labels: [String: String]) {
        serialQueue.sync {
            if started {
                let publisherConfig = SCORAnalytics.configuration().publisherConfiguration(withPublisherId: ComScoreAnalytics.configuration?.publisherId)
                labels.forEach {
                    publisherConfig?.setPersistentLabelWithName($0.0, value: $0.1)
                }
                SCORAnalytics.notifyHiddenEvent(withLabels: labels)
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

@frozen
public enum ComScoreError: Error {
    case notStarted
}
