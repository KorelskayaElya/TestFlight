//
//  DateFormatterHelper.swift
//  testAero
//
//  Created by Эля Корельская on 05.09.2024.
//

import OSLog

struct DateFormatterHelper {

    private static let logger: LoggerService = OSLogLogger.shared

    // форматирование даты из формата yyyy-MM-dd HH:mm в другие outputFormat
    static func formattedDate(from dateString: String?, inputFormat: String, outputFormat: String) -> String {
        guard let dateString = dateString, !dateString.isEmpty else {
            logger.logEvent(
                message: "[DateFormatterHelper] Empty or nil date string",
                type: .error
            )
            return ""
        }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "ru_RU")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        logger.logEvent(
            message: "[DateFormatterHelper] Trying to parse date: \(dateString) with input format: \(inputFormat)",
            type: .error
        )
        
        guard let date = inputFormatter.date(from: dateString) else {
            logger.logEvent(
                message: "[DateFormatterHelper] Failed to parse date from string: \(dateString)",
                type: .error
            )
            return ""
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = outputFormat
        displayFormatter.locale = Locale(identifier: "ru_RU")

        let formattedDate = displayFormatter.string(from: date)
        
        logger.logEvent(
            message: "[DateFormatterHelper] Successfully formatted date: \(formattedDate) with output format: \(outputFormat)",
            type: .other
        )
        
        return formattedDate
    }
}
