import OSLog

enum LogLevel {
    case debug
    case error
    case info
}

func log(_ level: LogLevel, _ message: String) {
    let logger: Logger = inject()

    switch level {
    case .debug: logger.debug("\(message, privacy: .public)")
    case .error: logger.error("\(message, privacy: .public)")
    case .info: logger.info("\(message, privacy: .public)")
    }
}

func log(_ request: URLRequest, _ level: LogLevel = .info, message: String? = nil) {
    log(level, "[⚡️Request] \(request.httpMethod ?? "?") \(request)")

    if let message {
        log(level, message)
    }
}
