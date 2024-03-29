//
//  Theme.swift
//  Dart01
//
//  Created by Eric Patterson on 12/31/23.
//

import SwiftUI

struct Theme {
    
    struct Fonts {
        static func raleway(_ size: CGFloat, _ style: Font.TextStyle) -> Font { return Font.custom("Raleway-Regular", size: size, relativeTo: style) }

        static func ralewaySemiBold(_ size: CGFloat, _ style: Font.TextStyle) -> Font { return Font.custom("Raleway-SemiBold", size: size, relativeTo: style) }
        
        static func raleway(_ size: FontSize, _ style: Font.TextStyle) -> Font { return Font.custom("Raleway-Regular", size: size.rawValue, relativeTo: style) }

        static func ralewaySemiBold(_ size: FontSize, _ style: Font.TextStyle) -> Font { return Font.custom("Raleway-SemiBold", size: size.rawValue, relativeTo: style) }
        
        static func ralewayBold(_ size: FontSize, _ style: Font.TextStyle) -> Font { return Font.custom("Raleway-Bold", size: size.rawValue, relativeTo: style) }
        
        static func ralewayBold(_ size: CGFloat, _ style: Font.TextStyle) -> Font { return Font.custom("Raleway-Bold", size: size, relativeTo: style) }
    }
    
    enum FontSize: CGFloat {
        case largeTitle = 34.0
        case title = 28.0
        case title2 = 22.0
        case title3 = 20.0
        case body = 17.0
        case callout = 16.0
        case subheadline = 15.0
        case footnote = 13.0
        case caption = 12.0
        case caption2 = 11.0
    }
    
    struct Spacing {
        static let extraExtraSmall: CGFloat = 5.0
        static let extraSmall: CGFloat = 10.0
        static let small: CGFloat = 12.0
        static let medium: CGFloat = 15.0
        static let large: CGFloat = 20.0
        static let extraLarge: CGFloat = 25.0
        static let extraExtraLarge: CGFloat = 30.0
    }
    
    struct CornerRadius {
        static let button = 10.0
        static let large = 30.0
    }
}

