//
//  UIView.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 17.04.2024.
//

import Foundation
import UIKit

extension UIView {
//    var asImg: UIImage? {
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { rendererContext in
//            layer.render(in: rendererContext.cgContext)
//        }
//    }
    
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultingImage!
    }
}
