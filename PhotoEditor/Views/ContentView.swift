//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        Home()
        Home2()
    }
}

//struct ContentView: View {
//    @State private var showingImagePicker = false
//    @State private var selectedImage: UIImage? = nil
//    @State private var showingDetailScreen = false
//    
//    var body: some View {
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [Color.edPlatinum, Color.edDarkAsh]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
//           Rectangle()
//                .frame(width: 200)
//                .background(.edThistle)
//                .foregroundColor(.edThistle)
//            Image(systemName: "livephoto").resizable()
//                .frame(width: 170)
//                .foregroundColor(.edLightGray)
//            
//            
//            VStack {
//                
//                HeadlineView()
//                Image(systemName: "scribble.variable").resizable()
//                    .frame(width: 50, height: 30)
//                    .foregroundColor(.edJat)
//                
//                Button(action: {
//                    self.showingImagePicker = true
//                }) {
//                    Text("Выбрать изображение")
//                }
//            }
//        }
//        .sheet(isPresented: $showingImagePicker, onDismiss: loadDetail) {
//            ImagePickerView(image: self.$selectedImage)
//        }
//        .fullScreenCover(isPresented: $showingDetailScreen) {
//            EditorView(image: selectedImage)
//        }
//    }
//    
//    func loadDetail() {
//        self.showingDetailScreen = true
//    }
//}
//
//struct ImagePickerView: UIViewControllerRepresentable {
//
//    @Environment(\.presentationMode)
//    var presentationMode
//
//    @Binding var image: UIImage?
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//        @Binding var presentationMode: PresentationMode
//        @Binding var image: UIImage?
//
//        init(presentationMode: Binding<PresentationMode>, 
//             image: Binding<UIImage?>
//        ) {
//            _presentationMode = presentationMode
//            _image = image
//        }
//
//        func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//            image = uiImage
//            presentationMode.dismiss()
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(presentationMode: presentationMode, image: $image)
//    }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
//    }
//}


#Preview {
    ContentView()
}
