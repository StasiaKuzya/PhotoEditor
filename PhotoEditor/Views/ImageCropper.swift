//
//  CustomImagePicker.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import SwiftUI
import Mantis
//TODO: crop and cut via Mantis or other ways

struct ImageCropper: UIViewControllerRepresentable {
    @Binding var image: UIImage
    @Binding var cropShapeType: Mantis.CropShapeType
    @Binding var presetFixedRatioType: Mantis.PresetFixedRatioType
    @EnvironmentObject var model: DrawingViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: CropViewControllerDelegate {
        var parent: ImageCropper
        
        init(_ parent: ImageCropper) {
            self.parent = parent
        }
        
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
            guard let data = cropped.pngData() else { return }
            parent.image = cropped
            print("transformation is \(transformation)")
            parent.model.imageData = data
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
            parent.model.croppedImage = cropped
            if let data = cropped.pngData() {
                self.parent.model.imageData = data
                print("after \(data)")
            } else {
                print("Failed to get PNG data for cropped UIImage.")
            }
            
            print("transformation is \(transformation)")
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        }
        
        func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        }
        
        func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CropViewController {
        var config = Mantis.Config()
        config.cropShapeType = cropShapeType
        config.presetFixedRatioType = presetFixedRatioType
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {
        
    }
}
