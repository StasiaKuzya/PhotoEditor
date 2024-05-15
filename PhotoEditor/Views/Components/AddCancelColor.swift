//
//  AddCancelColor.swift
//  PhotoEditor
//
//  Created by Анастасия on 15.05.2024.
//

import SwiftUI

struct AddCancelColor: View {
    @StateObject var model = DrawingViewModel()
    
    var body: some View {
        HStack {
            Button {
                model.textBox[model.currentIndex].isAdded = true
                model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                model.canvas.becomeFirstResponder()
                
                withAnimation {
                    model.addNewBox = false
                }
            } label: {
                Text("ADD")
            }
            Spacer()
            Button {
                model.cancelTextView()
            } label: {
                Text("CANCEL")
            }
        }
        .bold()
        .foregroundColor(.edLightGray)
        .padding()
        .background(.black)
    }
}

#Preview {
    AddCancelColor()
}
