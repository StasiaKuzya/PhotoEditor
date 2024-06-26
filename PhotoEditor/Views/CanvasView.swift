//
//  CanvasView.swift
//  PhotoEditor
//
//  Created by Анастасия on 15.05.2024.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var imageData: Data
    @Binding var toolPicker: PKToolPicker
    
    var rect: CGSize = UIScreen.main.bounds.size
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: UIColor.black, width: 1)
        
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
        }
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
       for subview in uiView.subviews[0].subviews {
          if subview is UIImageView {
             subview.removeFromSuperview()
          }
       }
       // Add new UIImageView
        if let image = UIImage(data: imageData) {
           let imageView = UIImageView(image: image)
          imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
          imageView.contentMode = .scaleAspectFit
          imageView.clipsToBounds = true
                    
          let subView = uiView.subviews[0]
          subView.addSubview(imageView)
          subView.sendSubviewToBack(imageView)
       }
    }
}
