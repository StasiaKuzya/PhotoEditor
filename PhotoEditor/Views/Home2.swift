//
//  Home2.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import SwiftUI
import PencilKit

struct Home2: View {
    @StateObject var model = DrawingViewModel()
    
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
                                    }
                                }
                            }
                    } else {
                        Button(action: {
                            model.showImagePicker.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                        })
                    }
                }
                .navigationTitle("nnn")
            }
            if model.addNewBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                TextField("Type here", text: $model.textBox[model.currentIndex].text)
                    .font(.system(size: 35,
                                  weight: model.textBox[model.currentIndex].isBool ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(model.textBox[model.currentIndex].textColor)
                    .padding()
                
                HStack {
                    Button {
                        model.textBox[model.currentIndex].isAdded = true
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.canvas.becomeFirstResponder()
                        
                        withAnimation {
                            model.addNewBox = false
                        }
                    } label: {
                        Text("Add")
                            .bold()
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        model.cancelTextView()
                    } label: {
                        Text("Cancel")
                            .bold()
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .overlay(
                    HStack(spacing: 15) {
                        ColorPicker("", selection: $model.textBox[model.currentIndex].textColor)
                            .labelsHidden()
                        
                        Button {
                            model.textBox[model.currentIndex].isBool.toggle()
                        } label: {
                            Text(model.textBox[model.currentIndex].isBool ? "Normal" : "Bold")
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
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
    Home2()
}
