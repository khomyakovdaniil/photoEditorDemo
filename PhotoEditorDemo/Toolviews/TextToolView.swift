//
//  TextToolView.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit

protocol TextToolDelegate: AnyObject {
    func didApply(text: String)
}

class TextToolView: UIView {

    class func instanceFromNib() -> TextToolView {
        return UINib(nibName: "TextToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TextToolView
    }
    
    weak var delegate: TextToolDelegate?
    
    @IBAction func didEnterText(_ sender: UITextField) {
        delegate?.didApply(text: sender.text!)
    }
    

}
