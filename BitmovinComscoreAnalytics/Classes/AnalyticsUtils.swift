//
//  AnalyticsUtils.swift
//  Pods
//
//  Created by aneurinc on 4/30/20.
//

import Foundation
import ComScore

func notifyHiddenEvent(publisherId: String, label: String, value: String) {
    let publisherConfig = SCORAnalytics.configuration().publisherConfiguration(withPublisherId: publisherId)
    publisherConfig?.setPersistentLabelWithName(label, value: value)
    SCORAnalytics.notifyHiddenEvent()
}

func notifyHiddenEvents(publisherId: String?, labels: [String: String]) {
    let publisherConfig = SCORAnalytics.configuration().publisherConfiguration(withPublisherId: publisherId)
    labels.forEach {
        publisherConfig?.setPersistentLabelWithName($0.0, value: $0.1)
    }
    SCORAnalytics.notifyHiddenEvent(withLabels: labels)
}
