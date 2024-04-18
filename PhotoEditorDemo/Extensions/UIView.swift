//
//  UIView.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 17.04.2024.
//

import Foundation
import UIKit

extension UIView {
    
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultingImage!
    }
}
