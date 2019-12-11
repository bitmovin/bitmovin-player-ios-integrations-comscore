# BitmovinComScoreAnalytics

## Installation

`BitmovinComScoreAnalytics` is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BitmovinComScoreAnalytics', git: 'https://github.com/bitmovin/bitmovin-player-ios-integrations-comscore.git', tag: 1.3.1'
```

Then, in your command line run:

```
pod install
```

You can optionally link against `AdSupport.Framework` to get correct syndicated reporting of the application usage data

## Usage

### Basic Setup
The following example shows how to setup the `ComScoreAnalytics`:
```swift

//In your AppDelegate.swift fine add this to your didFinishLaunchingWithOptions method

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let comscoreConfiguration: ComScoreConfiguration = ComScoreConfiguration(publisherId: "YOUR_PUBLISHER_ID", publisherSecret: "YOUR_PUBLISHER_SECRET", applicationName: "YOUR_APPLICATION_NAME")

    ComScoreAnalytics.addConfiguration(configuration: comscoreConfiguration)
    ComScoreAnalytics.start()

    return true
}
```
Then create a ComScoreStreamingAnalytics using your current  `BitmovinPlayer` 

```swift 
// Create a Comscore Configuration
let comScoreMetadata: ComScoreMetadata = ComScoreMetadata(mediaType: .longFormOnDemand, publisherBrandName: "ABC", programTitle: "Modern Family", episodeTitle: "Rash Decisions", episodeSeasonNumber: "1", episodeNumber: "2", contentGenre: "Comedy", stationTitle: "Hulu",completeEpisode: true)

do {
    try comScoreStreamingAnalytics = ComScoreAnalytics.createComScoreStreamingAnalytics(bitmovinPlayer: bitmovinPlayer, metadata: comScoreMetadata)
} catch {
    print("ComScoreAnalytics must be started before creating a ComScoreStreamingAnalytics object")
}

```

When changing assets, make sure to call `update(metadata:)` before loading a new asset 

```swift 

bitmovinPlayer.unload()

let newMetadata:ComScoreMetadata = ComScoreMetadata(mediaType: .longFormOnDemand,publisherBrandName: "ABC",programTitle: "Modern Family", episodeTitle: "Rash Decisions", episodeSeasonNumber: "1", episodeNumber: "2", contentGenre: "Comedy", stationTitle: "Hulu",completeEpisode: true)

comScoreStreamingAnalytics.update(metadata: newMetadata)

bitmovinPlayer.load(source)
```

Details about usage of `BitmovinPlayer` can be found [here](https://github.com/bitmovin/bitmovin-player-ios-sdk-cocoapod).


## Author

Cory Zachman, cory.zachman@bitmovin.com

## License

BitmovinComscoreAnalytics is available under the MIT license. See the LICENSE file for more info.
