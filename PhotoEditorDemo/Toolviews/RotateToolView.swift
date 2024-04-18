//
//  RotateToolView.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit

// Rotation functions performed by MainViewController, view only passes signals
protocol RotationToolDelegate: AnyObject {
    func didRotate()
    func didFlipVertical()
    func didFlipHorizontal()
}

class RotateToolView: UIView {
    
    // Create view from nib
    class func instanceFromNib() -> RotateToolView {
        return UINib(nibName: "RotateToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RotateToolView
    }
    
    // Should be MainViewController
    weak var delegate: RotationToolDelegate?
    
    
    // Passing user input to delegate
    @IBAction func didTapFlipHorizontal(_ sender: Any) {
        delegate?.didFlipHorizontal()
    }
    
    @IBAction func didTapFlipVertical(_ sender: Any) {
        delegate?.didFlipVertical()
    }
    
    @IBAction func didTapRotate(_ sender: Any) {
        delegate?.didRotate()
    }
}
