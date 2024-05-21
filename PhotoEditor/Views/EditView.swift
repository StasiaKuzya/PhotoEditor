//
//  EditView.swift
//  PhotoEditor
//
//  Created by Анастасия on 21.05.2024.
//

import SwiftUI
import PencilKit
import Mantis
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI

struct EditView: View {
    @EnvironmentObject var model: DrawingViewModel
    @State private var uiImage: UIImage? {
        didSet {
            loadImage()
        }
    }
    @State private var showingCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    
    @State private var showingFilters = false
    @State private var filterIntensety = 0.5
    @State private var currentFilter: CIFilter = CIFilter(name: "CISourceOverCompositing")!
    @State private var processedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingImagePicker = false
    
    let context = CIContext()
    
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
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if let editedImage = model.editPhoto() {
                        uiImage = editedImage
                        model.isShowingCropView = true
                        showingCropper = true
                    }
                    
                }, label: {
                    Image(systemName: "scissors")
                        .tint(.edLightGray)
                        .bold()
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if let editedImage = model.editPhoto() {
                        uiImage = editedImage
                        changeFilter()
                    }
                }, label: {
                    Image(systemName: "camera.filters")
                        .tint(.edLightGray)
                        .bold()
                })
                Slider(value: $filterIntensety)
                    .onChange(of: filterIntensety, applyProcessing)
            }            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .tint(.edLightGray)
                        .bold()
                })
//                if let processedImage = model.imageData { ShareLink(model.imageData, item: nil, subject: nil, message: SharePreview("PhotoEditor photo", image: model.imageData)) {}
//                }
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
            if showingCropper, let image = uiImage {
               ImageCropper(
                  image: Binding.constant(image),
                  cropShapeType: $cropShapeType,
                  presetFixedRatioType: $presetFixedRatioType)
            }
        })
        .confirmationDialog("select filter", isPresented: $showingFilters) {
//            Button("Normal") {setFilter(noFilter())}
            Button("Crystallize") {setFilter(CIFilter.crystallize())}
            Button("Sepia Tone") {setFilter(CIFilter.sepiaTone())}
            Button("Edges") {setFilter(CIFilter.edges())}
            Button("Pixellate") {setFilter(CIFilter.pixellate())}
            Button("Vignette") {setFilter(CIFilter.vignette())}
            Button("Unsharp Mask") {setFilter(CIFilter.unsharpMask())}
            Button("Gaussian Blur") {setFilter(CIFilter.gaussianBlur())}
        }
        .onAppear(perform: {
            self.reset()
        })
    }
    
    func getIndex(textBox: TextBox) ->Int {
        let index = model.textBox.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        return index
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensety, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensety * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensety * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage  = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = uiImage

        // Save it as Data for imageData
        if let filteredImageData = uiImage.pngData() {
            model.imageData = filteredImageData
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func noFilter() -> CIFilter {
        let noFilter = CIFilter(name: "CISourceOverCompositing")!
        return noFilter
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        for key in currentFilter.inputKeys {
            if let attribute = currentFilter.attributes[key] as? [String: Any],
               let defaultValue = attribute[kCIAttributeDefault] {
                currentFilter.setValue(defaultValue, forKey: key)
            }
        }
        if let uiImage = uiImage {
            let beginImage = CIImage(image: uiImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

            if let cioutput = currentFilter.outputImage {
                let cgoutput = context.createCGImage(cioutput, from: cioutput.extent)
                if cgoutput == nil {
                    print("Failed to create CGImage")
                } else {
                    let uioutput = UIImage(cgImage: cgoutput!)
                    self.processedImage = uioutput
                }
            } else {
                print("Failed to get output image from filter")
            }
        }
        applyProcessing()
    }
}

//#Preview {
//    EditView()
//}
