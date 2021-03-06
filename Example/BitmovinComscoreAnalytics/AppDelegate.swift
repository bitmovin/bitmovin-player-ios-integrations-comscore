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

        let comscoreConfiguration: ComScoreConfiguration = ComScoreConfiguration(
            publisherId: "YOUR_PUBLISHER_ID",
            applicationName: "YOUR_APPLICATION_NAME",
            userConsent: .granted,
            debug: true
        )
        ComScoreAnalytics.start(configuration: comscoreConfiguration)

        return true
    }
}
