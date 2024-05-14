//
//  HeadlineView.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import SwiftUI

struct HeadlineView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("WELCOME")
                .font(.largeTitle)
            Text(" Let's begin editing")
                .font(.subheadline)
                
        }
        .bold()
        .foregroundColor(.edJat)
    }
}

#Preview {
    HeadlineView()
}
