//
//  LogLevel.swift
//  Events
//
//  Created by Bruno on 03/11/24.
//


import Foundation
import OSLog

public enum LogLevel {
    case debug
    case info
    case warning
    case error
    
    fileprivate var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        }
    }
    
    fileprivate var name: StaticString {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        }
    }
}

public final class Logger {
    private let subsystem: String
    private let category: String
    private let osLog: OSLog
    private let queue: DispatchQueue
    
    public static let shared = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.default", category: "General")
    
    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.osLog = OSLog(subsystem: subsystem, category: category)
        self.queue = DispatchQueue(label: "com.logger.\(subsystem).\(category)", qos: .utility)
    }
    
    public func log(
        _ message: String,
        level: LogLevel = .info,
        fileName: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        #if DEBUG
        // Captura os valores que podem mudar antes de entrar na queue
        let file = (fileName as NSString).lastPathComponent
        let timestamp = Date().ISO8601Format()
        
        queue.async {
            os_log(
                level.osLogType,
                log: self.osLog,
                "%{private}@ [%{private}@] %{private}@:%{private}d %{private}@ - %{public}@",
                timestamp,
                level.name,
                file,
                line,
                function,
                message
            )
        }
        #endif
    }
    
    public func debug(_ message: String, fileName: String = #file, line: Int = #line, function: String = #function) {
        log(message, level: .debug, fileName: fileName, line: line, function: function)
    }
    
    public func info(_ message: String, fileName: String = #file, line: Int = #line, function: String = #function) {
        log(message, level: .info, fileName: fileName, line: line, function: function)
    }
    
    public func warning(_ message: String, fileName: String = #file, line: Int = #line, function: String = #function) {
        log(message, level: .warning, fileName: fileName, line: line, function: function)
    }
    
    public func error(_ message: String, fileName: String = #file, line: Int = #line, function: String = #function) {
        log(message, level: .error, fileName: fileName, line: line, function: function)
    }
    
    deinit {
        queue.sync {} // Garante que todos os logs pendentes sejam processados
    }
}