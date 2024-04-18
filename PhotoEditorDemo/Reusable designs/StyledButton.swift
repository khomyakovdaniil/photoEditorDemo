//
//  StyledButton.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 18.04.2024.
//

import UIKit

class StyledButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.green.cgColor
    }

}
