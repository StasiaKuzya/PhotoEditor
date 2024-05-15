//
//  DrawingScreen.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import SwiftUI
import PencilKit
import Mantis

struct DrawingScreen: View {
    @EnvironmentObject var model: DrawingViewModel
    @State private var uiImage: UIImage = UIImage(named:"placeholder")!
    @State private var showingCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    
    func reset() {
        if let image = UIImage(data: model.imageData) {
            uiImage = image
        } else {
            print("image data could not be converted to uiImage")
        }
        cropShapeType = .rect
        presetFixedRatioType = .canUseMultiplePresetFixedRatio()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.edJat, Color.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
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
                Button(action: {
                    reset()
                    model.isShowingCropView.toggle()
                    model.isShowingCropView = true
                    showingCropper = true
                }, label: {
                    Image(systemName: "scissors")
                        .tint(.edLightGray)
                        .bold()
                })
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
                    Image(systemName: "textformat")
                        .tint(.edLightGray)
                        .bold()
                })

            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    model.saveImage()
                } label: {
                    Text("Save")
                        .bold()
                        .foregroundColor(.edLightGray)
                }
            }
        }
        .fullScreenCover(isPresented: $showingCropper, content: {
            ImageCropper(
                image: $uiImage,
                         cropShapeType: $cropShapeType,
                         presetFixedRatioType: $presetFixedRatioType)
                .ignoresSafeArea()
        })
    }
    
    func getIndex(textBox: TextBox) ->Int {
        let index = model.textBox.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        return index
    }
}

#Preview {
    PickPhotoView()
}
