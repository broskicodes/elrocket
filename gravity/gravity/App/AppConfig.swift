//
//  AppConfig.swift
//  gravity
//
//  Created by Braeden Hall on 2025-07-10.
//

import Foundation
import SwiftUI

struct AppConfig {
    @AppStorage("device_id") static var deviceID: String = UUID().uuidString

    static let bleServiceID: String = "FFE0"
    static let bleNotifyCharID: String = "FFE1"
    static let bleWriteCharID: String = "FFE2"
}
