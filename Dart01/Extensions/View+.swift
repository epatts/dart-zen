//
//  View+.swift
//  Dart01
//
//  Created by Eric Patterson on 3/20/24.
//

import SwiftUI

extension View {
    func backButtonWithTitleNavBarStyle(title: String) -> some View {
        modifier(BackButtonWithTitleNavBarStyle(title: title))
    }
}

extension View {
    func glow(color: Color = Color(.primaryDark), radius: CGFloat = 5) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
}
