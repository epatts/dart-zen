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
            .frame(width: 92, height: 56)
            .background ( ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondaryDark))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
                    .shadow(color: Color ("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color ("DarkShadow"), radius: 8, x: 8, y: 8)
            })
            .foregroundStyle(Color(.textXlight))
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
            .font(.title2SemiBold)
            .frame(width: 92, height: 56)
            .background ( ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.neutralXlight))
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
                    .shadow(color: Color ("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color ("DarkShadow"), radius: 8, x: 8, y: 8)
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
            .frame(width: 126, height: 66)
            .background ( ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.primaryDark))
                    .frame(maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
                    .shadow(color: Color ("LightShadow"), radius: 8, x: -8, y: -8)
                    .shadow(color: Color ("DarkShadow"), radius: 8, x: 8, y: 8)
            })
            .foregroundStyle(Color(.neutralXxlight))
            .opacity(configuration.isPressed ? 0.75 : 1)
            .conditionalEffect(
                .pushDown,
                condition: configuration.isPressed
            )
    }
}
