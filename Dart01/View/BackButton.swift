//
//  BackButton.swift
//  Dart01
//
//  Created by Eric Patterson on 3/20/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .foregroundStyle(Color(.primaryDark))
                .font(.title3SemiBold)
        }
    }
}

#Preview {
    return BackButton()
}
