//
//  ViewStyles.swift
//  Dart01
//
//  Created by Eric Patterson on 1/15/24.
//

import SwiftUI
import Pow

struct CommonScoreButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
    configuration.label
            .font(Theme.Fonts.ralewaySemiBold(.body, .body))
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .foregroundStyle(Color(.textXlight))
            .background(Color(.secondaryDark))
            .opacity(configuration.isPressed ? 0.75 : 1)
            .conditionalEffect(
                .pushDown,
                condition: configuration.isPressed
            )
    }
}

struct CommonScoreTextFieldStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
    configuration.label
            .font(Theme.Fonts.ralewaySemiBold(.body, .body))
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .padding(.leading)
            .foregroundStyle(Color(.textBase))
            .background(Color(.neutralLight))
            .opacity(configuration.isPressed ? 0.75 : 1)
            .conditionalEffect(
                .pushDown,
                condition: configuration.isPressed
            )
    }
}

struct NumberPadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
    configuration.label
            .font(Theme.Fonts.ralewaySemiBold(.title2, .title2))
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
            .foregroundStyle(Color(.textXlight))
            .background(Color(.primaryDark))
            .opacity(configuration.isPressed ? 0.75 : 1)
            .conditionalEffect(
                .pushDown,
                condition: configuration.isPressed
            )
    }
}
