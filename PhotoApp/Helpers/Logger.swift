//
//  Logger.swift
//  JobsApp
//
//  Created by Варвара Уткина on 27.11.2024.
//

/*
import Foundation

enum Log {
    static func debug(
        _ data: @autoclosure () -> Any?,
        file: String = #file,
        line: Int = #line
    ) {
        print("\n\n📗 [DEBUG][START]: \(String(describing: data() ?? "nil")) \n\n📗 [FILE]: \(extractFileName(from: file)) \n📗 [LINE]: \(line) \n📗 [END]\n")
    }
    
    static func error(
        _ data: @autoclosure () -> Any?,
        file: String = #file,
        line: Int = #line
    ) {
        print("\n\n📕 [ERROR][START]: \(String(describing: data() ?? "nil")) \n\n📕 [FILE]: \(extractFileName(from: file)) \n📕 [LINE]: \(line) \n📕 [END]\n")
    }
    
    private static func extractFileName(from path: String) -> String {
        return path.components(separatedBy: "/").last ?? ""
    }
}
*/

import OSLog

enum Log {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "utkina.PhotoAppTests"
    
    static var isGeneralEnabled = true
    static var isNetworkingEnabled = true
    static var isUIEnabled = false
    
    struct TaggedLogger {
        let logger: Logger
        let category: String
    }
    
    static let general = TaggedLogger(
        logger: Logger(subsystem: subsystem, category: "general"),
        category: "general"
    )
    
    static let networking = TaggedLogger(
        logger: Logger(subsystem: subsystem, category: "networking"),
        category: "networking"
    )
    
    static let ui = TaggedLogger(
        logger: Logger(subsystem: subsystem, category: "ui"),
        category: "ui"
    )
}

extension Log {
    static func debug(
        _ message: String,
        logger: TaggedLogger = Log.general,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        guard isCategoryEnabled(for: logger) else { return }
        
        logger.logger.debug("\n📗 \(message, privacy: .public)\n\n\(formatLocation(file: file, function: function, line: line))")
    }
    
    static func error(
        _ message: String,
        logger: TaggedLogger = Log.general,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        guard isCategoryEnabled(for: logger) else { return }
        
        logger.logger.error("\n📕 \(message, privacy: .public)\n\n\(formatLocation(file: file, function: function, line: line))")
    }
    
    private static func formatLocation(file: String, function: String, line: Int) -> String {
        let fileName = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        return """
        📄 \(fileName)
        〽️ func \(function)
        Line: \(line)
        """
    }
    
    private static func isCategoryEnabled(for logger: TaggedLogger) -> Bool {
        switch logger.category {
        case "networking": return isNetworkingEnabled
        case "ui": return isUIEnabled
        case "general": return isGeneralEnabled
        default: return true
        }
    }
}
