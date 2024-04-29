//
//  LoggerExtension.swift
//  AppleItunesCatalog
//
//  Created by SCOTT CROWDER on 4/29/24.
//

import Foundation
import os.log

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.me.test"
    static let general = Logger(subsystem: subsystem, category: "general")
    static let networking = Logger(subsystem: subsystem, category: "networking")
}
