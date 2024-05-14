//
//  Crop.swift
//  PhotoEditor
//
//  Created by Анастасия on 14.05.2024.
//

import SwiftUI

enum Crop: Equatable {
    case circle
    case rectangle
    case squre
    case custom(CGSize)
    
    func name() -> String {
        switch self {
        case .circle:
            return "Circle"
        case .rectangle:
            return "Rectangle"
        case .squre:
            return "Squre"
        case .custom(let cGSize):
            return "Custom \(Int(cGSize.width))X\(Int(cGSize.height))"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .circle:
            return .init(width: 400, height: 400)
        case .rectangle:
            return .init(width: 400, height: 600)
        case .squre:
            return .init(width: 400, height: 400)
        case .custom(let cGSize):
            return cGSize
        }
    }
}
