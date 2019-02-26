//
//  AppDelegate.swift
//  BitmovinComscoreAnalytics
//
//  Created by Cory Zachman on 11/25/2018.
//  Copyright (c) 2018 Cory Zachman. All rights reserved.
//

import UIKit
import BitmovinComScoreAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let comscoreConfiguration: ComScoreConfiguration = ComScoreConfiguration(publisherId: "YOUR_PUBLISHER_ID",
                                                                                 publisherSecret: "YOUR_PUBLISHER_SECRET",
                                                                                 applicationName: "YOUR_APPLICATION_NAME")
        ComScoreAnalytics.start(configuration: comscoreConfiguration)

        return true
    }
}
