import ComScore
import BitmovinPlayer

public final class ComScoreAnalytics {

    public static func start() {
        SCORAnalytics.start()
    }

    public static func addConfiguration(configuration: ComScoreConfiguration) {
        let builder = SCORPublisherConfigurationBuilder.init()
        builder.publisherId = configuration.publisherId
        builder.publisherSecret = configuration.publisherSecret
        builder.applicationName = configuration.applicationName
        SCORAnalytics.configuration()?.addClient(with: builder.build())
    }

}
