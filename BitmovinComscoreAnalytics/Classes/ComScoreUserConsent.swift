//
//  ComScoreUserConsent.swift
//  Pods
//
//  Created by aneurinc on 12/11/19.
//

import Foundation

@frozen
public enum ComScoreUserConsent: String {
    case denied = "0"
    case granted = "1"
    case unknown = "-1"
}
