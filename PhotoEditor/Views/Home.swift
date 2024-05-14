//
//  Home.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import SwiftUI

struct Home: View {
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    var body: some View {
        NavigationStack{
            VStack() {
                if let croppedImage {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame()
                } else {
                    Text("No image is selected")
                        .font(.caption)
                }
            }
            .navigationTitle("Crop Image Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showPicker.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(.caption)
                    }
                    .tint(.black)
                }
            }
            .cropImagePicker(options: [.circle, .rectangle, .squre, .custom(.init(width: 300, height: 500))], show: $showPicker, croppedImage: $croppedImage)
        }
    }
}

#Preview {
    Home()
}
