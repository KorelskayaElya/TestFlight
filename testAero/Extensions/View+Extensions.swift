//
//  View+Extensions.swift
//  testAero
//
//  Created by Эля Корельская on 07.09.2024.
//

import SwiftUI

// MARK: - Extension

extension View {
    func customCardStyle() -> some View {
        self.modifier(CustomCardModifier())
    }
}
