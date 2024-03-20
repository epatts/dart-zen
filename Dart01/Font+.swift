//
//  Font+.swift
//  Dart01
//
//  Created by Eric Patterson on 3/20/24.
//

import SwiftUI

extension Font {
    // Regular fonts
    static func customRegular(_ size: CGFloat) -> Font { Theme.Fonts.raleway(size, .title) }
    
    static var largeTitleRegular = Theme.Fonts.raleway(.largeTitle, .largeTitle)
    static var titleRegular = Theme.Fonts.raleway(.title, .title)
    static var title2Regular = Theme.Fonts.raleway(.title2, .title2)
    static var title3Regular = Theme.Fonts.raleway(.title3, .title3)
    static var bodyRegular = Theme.Fonts.raleway(.body, .body)
    static var calloutRegular = Theme.Fonts.raleway(.callout, .callout)
    static var subheadlineRegular = Theme.Fonts.raleway(.subheadline, .subheadline)
    static var footnoteRegular = Theme.Fonts.raleway(.footnote, .footnote)
    static var captionRegular = Theme.Fonts.raleway(.caption, .caption)
    static var caption2Regular = Theme.Fonts.raleway(.caption2, .caption2)
    
    // SemiBold fonts
    static func customSemiBold(_ size: CGFloat) -> Font { Theme.Fonts.ralewaySemiBold(size, .title) }
    
    static var largeTitleSemiBold = Theme.Fonts.ralewaySemiBold(.largeTitle, .largeTitle)
    static var titleSemiBold = Theme.Fonts.ralewaySemiBold(.title, .title)
    static var title2SemiBold = Theme.Fonts.ralewaySemiBold(.title2, .title2)
    static var title3SemiBold = Theme.Fonts.ralewaySemiBold(.title3, .title3)
    static var bodySemiBold = Theme.Fonts.ralewaySemiBold(.body, .body)
    static var calloutSemiBold = Theme.Fonts.ralewaySemiBold(.callout, .callout)
    static var subheadlineSemiBold = Theme.Fonts.ralewaySemiBold(.subheadline, .subheadline)
    static var footnoteSemiBold = Theme.Fonts.ralewaySemiBold(.footnote, .footnote)
    static var captionSemiBold = Theme.Fonts.ralewaySemiBold(.caption, .caption)
    static var caption2SemiBold = Theme.Fonts.ralewaySemiBold(.caption2, .caption2)
    
    // Bold fonts
    static func customBold(_ size: CGFloat) -> Font { Theme.Fonts.ralewayBold(size, .title) }
    
    static var largeTitleBold = Theme.Fonts.ralewayBold(.largeTitle, .largeTitle)
    static var titleBold = Theme.Fonts.ralewayBold(.title, .title)
    static var title2Bold = Theme.Fonts.ralewayBold(.title2, .title2)
    static var title3Bold = Theme.Fonts.ralewayBold(.title3, .title3)
    static var bodyBold = Theme.Fonts.ralewayBold(.body, .body)
    static var calloutBold = Theme.Fonts.ralewayBold(.callout, .callout)
    static var subheadlineBold = Theme.Fonts.ralewayBold(.subheadline, .subheadline)
    static var footnoteBold = Theme.Fonts.ralewayBold(.footnote, .footnote)
    static var captionBold = Theme.Fonts.ralewayBold(.caption, .caption)
    static var caption2Bold = Theme.Fonts.ralewayBold(.caption2, .caption2)
}
