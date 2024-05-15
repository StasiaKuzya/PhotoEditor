//
//  TextBox.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import Foundation
import SwiftUI
import PencilKit

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var text: String = ""
    var isBool: Bool = false
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .black
    var isAdded: Bool = false
}
