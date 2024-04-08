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
            .font(.title2SemiBold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background ( ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.neutralDark))
            })
            .foregroundStyle(Color(.textBase))
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
            .font(.titleSemiBold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background ( ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.neutralXxlight))
                    .glow()
            })
            .foregroundStyle(Color(.textBase))
            .opacity(configuration.isPressed ? 0.75 : 1)
            .conditionalEffect(
                .pushDown,
                condition: configuration.isPressed
            )
    }
}
