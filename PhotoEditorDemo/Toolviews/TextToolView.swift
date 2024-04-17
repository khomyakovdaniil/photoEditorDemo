//
//  TextToolView.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit
import Foundation

protocol TextToolDelegate: AnyObject {
    func didApply(text: String)
}

class TextToolView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let fonts = ["Helvetica Bold", "Impact", "Papyrus"]
    let colors: [UIColor] = [.red, .green, .white]
    var font = "Helvetica Bold"
    var color: UIColor = .red
    

    @IBOutlet weak var fontPicker: UIPickerView!
    
    @IBOutlet weak var fontSizeField: UITextField!
    
    @IBOutlet weak var colorPicker: UIPickerView!
    
    class func instanceFromNib() -> TextToolView {
        let view = UINib(nibName: "TextToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TextToolView
        view.fontPicker.dataSource = view
        view.fontPicker.delegate = view
        view.colorPicker.dataSource = view
        view.colorPicker.delegate = view
        return view
    }
    
    weak var delegate: TextToolDelegate?
    
    @IBAction func didEnterText(_ sender: UITextField) {
        delegate?.didApply(text: sender.text!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == fontPicker {
            let label = UILabel()
            label.text = fonts[row]
            return label
        } else {
            let view = UILabel()
            view.backgroundColor = colors[row]
            return view
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fontPicker {
            font = fonts[row]
        } else {
            color = colors[row]
        }
    }
    

}
