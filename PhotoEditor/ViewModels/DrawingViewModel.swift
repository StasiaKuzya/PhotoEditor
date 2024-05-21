//
//  DrawingViewModel.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import Foundation
import PencilKit
import SwiftUI

class DrawingViewModel: ObservableObject {
    @Published var showImagePicker = false
    @Published var imageData: Data = Data(count: 0) {
        didSet {
            print("imageData changed \(imageData)")
        }
    }
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    @Published var textBox: [TextBox] = []
    @Published var addNewBox = false
    @Published var currentIndex: Int = 0
    @Published var rect: CGRect = .zero
    @Published var showAlert = false
    @Published var message = ""
    @Published var isShowingCropView = false
    @Published var croppedImage: UIImage?
    
    func cancelImageEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBox.removeAll()
    }
    
    func cancelTextView() {
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        addNewBox = false
        
        if !textBox[currentIndex].isAdded {
            textBox.removeLast()
        }
    }
    
    func editPhoto() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let swiftUIView = ZStack {
            ForEach(textBox) { box in
                Text(
                    self.textBox[self.currentIndex].id == box.id &&
                    self.addNewBox ? "" : box.text
                )
                .font(.system(size: 30))
                .fontWeight(box.isBool ? .bold : .none)
                .foregroundColor(box.textColor)
                .offset(box.offset)
            }
        }
        
        let controller = UIHostingController(rootView: swiftUIView).view!
        controller.frame = rect
        controller.backgroundColor = .clear
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return generatedImage
    }
    
    func saveImage() {
        if let image = editPhoto() {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.message = "Saved successfully"
            self.showAlert.toggle()
        } else {
            self.message = "An error occurred while editing the photo."
            self.showAlert.toggle()
        }
    }
//    func saveImage() {
//        editPhoto()
//        
//        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        if let image = generatedImage?.pngData() {
//            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
//            print("success")
//            self.message = "Saved successfully"
//            self.showAlert.toggle()
//        }
//    }
//    
//    func editPhoto() {
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
//        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
//        
//        let swiftUIView = ZStack {
//            ForEach(textBox) { [self] box in
//                Text(
//                    textBox[currentIndex].id == box.id
//                    && addNewBox ? "" : box.text)
//                .font(.system(size: 30))
//                .fontWeight(box.isBool ? .bold : . none)
//                .foregroundColor(box.textColor)
//                .offset(box.offset)
//            }
//        }
//        
//        let controller = UIHostingController(rootView: swiftUIView).view!
//        controller.frame = rect
//        controller.backgroundColor = .clear
//        canvas.backgroundColor = .clear
//        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
//
//        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//    }
}
