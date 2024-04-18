//
//  StyledButton.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 18.04.2024.
//

import UIKit

class StyledButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.green.cgColor
    }

}
