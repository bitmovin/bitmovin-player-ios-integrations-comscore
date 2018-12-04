import ComScore
import BitmovinPlayer

public final class ComScoreAnalytics {
    /**
     Starts the ComScoreAnalytics monitoring. Must be called before creating a ComScoreStreamingAnalytics object
     */
    public static func start() {
        SCORAnalytics.start()
    }

    /**
     Adds a ComScoreConfiguration to be used with ComScoreAnalytics. This is required before calling start()
     
     - Parameters:
     - configuration: The ComScoreConfiguration that contains your application specific information
     */
    public static func addConfiguration(configuration: ComScoreConfiguration) {
        let builder = SCORPublisherConfigurationBuilder()
        builder.publisherId = configuration.publisherId
        builder.publisherSecret = configuration.publisherSecret
        builder.applicationName = configuration.applicationName
        SCORAnalytics.configuration()?.addClient(with: builder.build())
    }

}
