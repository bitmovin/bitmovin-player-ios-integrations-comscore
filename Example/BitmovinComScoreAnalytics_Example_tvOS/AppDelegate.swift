//
//  AppDelegate.swift
//  BitmovinComScoreAnalytics_Example_tvOS
//
//  Created by Cory Zachman on 2/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import BitmovinComScoreAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let comscoreConfiguration: ComScoreConfiguration = ComScoreConfiguration(publisherId: "YOUR_PUBLISHER_ID", publisherSecret: "YOUR_PUBLISHER_SECRET", applicationName: "YOUR_APPLICATION_NAME")
        ComScoreAnalytics.start(configuration: comscoreConfiguration)
    
        return true
    }
}

