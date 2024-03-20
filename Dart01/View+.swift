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
