//
//  CollapsableContent.swift
//  Dart01
//
//  Created by Eric Patterson on 3/23/24.
//

import SwiftUI

struct CollapsableContent<Content: View>: View {
    
    var title: String
    var content: Content
    
    init(title: String, content: Content) {
        self.content = content
        self.title = title
    }
    
    @State var showingContent = true
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Text(title)
                    .font(.title3SemiBold)
                    .foregroundStyle(Color.secondaryDark)
                
                Spacer()
                
                Text(showingContent ? "Collapse" : "Expand")
                    .font(.bodySemiBold)
                    .foregroundStyle(Color.primaryDark)
                
                Image(systemName: showingContent ?  "chevron.up.circle" : "chevron.down.circle")
                    .font(.bodySemiBold)
                    .foregroundStyle(Color.primaryDark)
            }
            .padding(.bottom, .small)
            .contentShape(Rectangle())
            .onTapGesture {
                showingContent.toggle()
            }
            
            if showingContent {
                content
            }
        }
    }
}

#Preview {
    CollapsableContent(title: "Title", content: Text("content"))
        .padding(.medium)
}
