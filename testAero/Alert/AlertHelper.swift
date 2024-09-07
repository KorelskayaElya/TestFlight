//
//  AlertHelper.swift
//  testAero
//
//  Created by Эля Корельская on 06.09.2024.
//

import SwiftUI

struct AlertHelper {
    // алерт с title, message и кнопкой dismiss
    static func showAlertDismiss(title: String? = nil, message: String, dismissText: String) -> Alert {
        Alert(
            title: Text("\(title ?? "")"),
            message: Text(message),
            dismissButton: .default(Text(dismissText))
        )
    }
}
