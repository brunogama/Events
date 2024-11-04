import Foundation
import OSLog

enum Constants {
    static let bunndle = "br.com.bruno.Events"
}

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

    fileprivate var name: String {
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

    private static let shared = Logger(subsystem: Constants.bunndle, category: "General")

    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.osLog = OSLog(subsystem: subsystem, category: category)
        self.queue = DispatchQueue(label: "com.logger.\(subsystem).\(category)", qos: .background)
    }

    private static func log(
        _ message: String,
        level: LogLevel = .info,
        fileName: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        #if DEBUG
            let file = (fileName as NSString).lastPathComponent
            let timestamp = Date().ISO8601Format()

            shared.queue.async {
                os_log(
                    level.osLogType,
                    log: Self.shared.osLog,
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

    static public func debug(
        _ message: String,
        fileName: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        Self.log(message, level: .debug, fileName: fileName, line: line, function: function)
    }

    static public func info(
        _ message: String,
        fileName: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        Self.log(message, level: .info, fileName: fileName, line: line, function: function)
    }

    static public func warning(
        _ message: String,
        fileName: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        Self.log(message, level: .warning, fileName: fileName, line: line, function: function)
    }

    static public func error(
        _ message: String,
        fileName: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        Self.log(message, level: .error, fileName: fileName, line: line, function: function)
    }

    deinit {
        queue.async {}
    }
}
