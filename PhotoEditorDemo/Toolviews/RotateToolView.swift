//
//  RotateToolView.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit

protocol RotationToolDelegate: AnyObject {
  func didRotate(to degrees: Float)
}

class RotateToolView: UIView {
    
    class func instanceFromNib() -> RotateToolView {
        return UINib(nibName: "RotateToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RotateToolView
    }
    
    weak var delegate: RotationToolDelegate?
    
    @IBAction func didTapLeft(_ sender: Any) {
        delegate?.didRotate(to: -90)
    }
    
    @IBAction func didTapRight(_ sender: Any) {
        delegate?.didRotate(to: 90)
    }
}
