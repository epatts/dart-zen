//
//  ViewModifiers.swift
//  Dart01
//
//  Created by Eric Patterson on 3/20/24.
//

import SwiftUI

struct BackButtonWithTitleNavBarStyle: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .foregroundStyle(Color(.textBase))
                        .font(.title3SemiBold)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
            }
    }
    
}
