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

struct TipPopover: ViewModifier {
    @Binding var showingTip: Bool
    var parentView: AnyView
    
    init(showingTip: Binding<Bool>, parentView: AnyView) {
        self._showingTip = showingTip
        self.parentView = parentView
    }

    func body(content: Content) -> some View {
        content
            .popover(isPresented: $showingTip) {
                ZStack {
                    // Scaled-up background
                    Color(.neutralDark)
                        .scaleEffect(3)
                    
                    VStack {
                        parentView
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Button {
                            showingTip = false
                        } label: {
                            Text("Got it!")
                                .font(.subheadlineSemiBold)
                                .foregroundStyle(Color(.textBase))
                        }
                        .padding(.extraSmall)
                        .background(Color(.secondaryDark))
                        .clipShape(.capsule)
                    }
                }
                    .frame(minWidth: 300, maxHeight: 600)
                    .padding(.vertical, .extraExtraLarge)
                    .padding(.horizontal, .medium)
                    .presentationCompactAdaptation(.popover)
            }
    }
    
}
