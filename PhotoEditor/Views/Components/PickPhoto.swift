//
//  PickPhoto.swift
//  PhotoEditor
//
//  Created by Анастасия on 15.05.2024.
//

import SwiftUI

struct PickPhoto: View {
    var body: some View {
        VStack {
            Image(systemName: "photo.on.rectangle.angled")
                .resizable()
                .font(.title)
                .frame(width: 60, height: 50)
                .padding()
            Text("PICK A PHOTO")
                .bold()
                .font(.largeTitle)
                .padding()
        }
        .foregroundStyle(.edLightGray)
        .background(.clear)
        .cornerRadius(15)
        .shadow(color: .white, radius: 10)
    }
}

#Preview {
    PickPhoto()
}
