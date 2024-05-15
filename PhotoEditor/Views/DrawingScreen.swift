//
//  DrawingScreen.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { proxy -> AnyView in
                let size = proxy.frame(in: .global)
                
                DispatchQueue.main.async {
                    if model.rect == .zero {
                        model.rect = size
                    }
                }
                
                return AnyView( 
                    ZStack {
                        CanvasView(
                            canvas: $model.canvas,
                            imageData: $model.imageData,
                            toolPicker: $model.toolPicker,
                            rect: size.size)
                        
                        ForEach(model.textBox) { box in
                            Text(
                                model.textBox[model.currentIndex].id == box.id
                                && model.addNewBox ? "" : box.text)
                                .font(.system(size: 30))
                                .fontWeight(box.isBool ? .bold : . none)
                                .foregroundColor(box.textColor)
                                .offset(box.offset)
                                .gesture(DragGesture()
                                    .onChanged({ (value) in
                                        let current = value.translation
                                        let lastOffset = box.lastOffset
                                        let newTranslation = CGSize(
                                            width: lastOffset.width + current.width,
                                            height: lastOffset.height + current.height)
                                        
                                        model.textBox[getIndex(textBox: box)].offset = newTranslation
                                        
                                }).onEnded({ (value) in
                                    model.textBox[getIndex(textBox: box)].lastOffset = value.translation
                                }))
                                .onLongPressGesture {
                                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                                    model.canvas.resignFirstResponder()
                                    model.currentIndex = getIndex(textBox: box)
                                    withAnimation {
                                        model.addNewBox = true
                                    }
                                }
                        }
                    })
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    model.saveImage()
                } label: {
                    Text("Save")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    model.textBox.append(TextBox())
                    model.currentIndex = model.textBox.count - 1
                    
                    withAnimation {
                        model.addNewBox.toggle()
                    }
                    
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()
                }, label: {
                    Image(systemName: "plus")
                })

            }
        }
    }
    
    func getIndex(textBox: TextBox) ->Int {
        let index = model.textBox.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        return index
    }
}

#Preview {
    Home2()
}


