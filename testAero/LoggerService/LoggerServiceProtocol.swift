//
//  LoggerServiceProtocol.swift
//  testAero
//
//  Created by Эля Корельская on 06.09.2024.
//

import UIKit

protocol LoggerService: AnyObject {
    func logEvent(message: String, type: LoggerEventType)
}
