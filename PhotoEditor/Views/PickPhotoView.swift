//
//  PickPhotoView.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import SwiftUI
import PencilKit

struct PickPhotoView: View {
    @StateObject var model = DrawingViewModel()
    @State private var isShowingCropView = false
    
    var body: some View {
        ZStack {
            NavigationStack{
                VStack {
                    if let _ = UIImage(data: model.imageData) {
                        DrawingScreen()
                            .environmentObject(model)
                        
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        model.cancelImageEditing()
                                    } label: {
                                        Image(systemName: "xmark")
                                            .tint(.edLightGray)
                                            .bold()
                                    }
                                }
                            }
                    } else {
                        Button(action: {
                            model.showImagePicker.toggle()
                        }, label: {
                            PickPhoto()
                        })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.edJat, Color.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                    )
            }
            if model.addNewBox {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                TextField("Type here", text: $model.textBox[model.currentIndex].text)
                    .font(.system(size: 30,
                                  weight: model.textBox[model.currentIndex].isBool ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(model.textBox[model.currentIndex].textColor)
                    .padding()
                    .foregroundColor(.edLightGray)
                    .bold()
                
                AddCancelColor(model: model)
                    .overlay(
                        HStack(spacing: 15) {
                            ColorPicker("", selection: $model.textBox[model.currentIndex].textColor)
                                .labelsHidden()
                            
                            Button {
                                model.textBox[model.currentIndex].isBool.toggle()
                            } label: {
                                Text(model.textBox[model.currentIndex].isBool ? "NORMAL" : "BOLD")
                                    .bold()
                                    .foregroundColor(.edLightGray)
                            }
                        }
                    )
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .sheet(isPresented: $model.showImagePicker,
               content: {
            ImagePicker(showPicker: $model.showImagePicker, imageData: $model.imageData)
        })
        .alert(isPresented: $model.showAlert, content: {
            Alert(title: Text("Message"),
                  message: Text(model.message),
                  dismissButton: .default(Text("OK")))
        })
    }
}

#Preview {
    PickPhotoView()
}
