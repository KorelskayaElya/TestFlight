//
//  CustomCardModifier.swift
//  testAero
//
//  Created by Эля Корельская on 07.09.2024.
//

import SwiftUI

// MARK: - Custom ViewModifier

struct CustomCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.backgroundSecondary)
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding(.horizontal)
    }
}
