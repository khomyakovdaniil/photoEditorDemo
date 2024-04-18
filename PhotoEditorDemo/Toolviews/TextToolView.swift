//
//  TextToolView.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit
import Foundation

class TextToolView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Fonts and colors are stored in constants for easy editing
    let fonts = Constants.Tools.fonts
    let colors = Constants.Tools.colors
    // All the properties are stored in the view itself, to be accessable from MainViewController
    // This is an awful solution, but what choice do I have?
    var font = Constants.Tools.fonts[0]
    var color = Constants.Tools.colors[0]
    var size: Double = 25
    
    
    // Outlets
    @IBOutlet weak var fontPicker: UIPickerView!

    @IBOutlet weak var fontSizeLabel: UILabel!
    
    @IBOutlet weak var fontSizeStepper: UIStepper!
    
    @IBOutlet weak var colorPicker: UIPickerView!
    
    
    // Passing the value from stepper to label and corresponding propertie
    @IBAction func fontSizeChanged(_ sender: UIStepper) {
        size = sender.value
        fontSizeLabel.text = String(size)
    }
    
    // Creating view from nib and configuring all the views
    class func instanceFromNib() -> TextToolView {
        let view = UINib(nibName: "TextToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TextToolView
        view.fontPicker.dataSource = view
        view.fontPicker.delegate = view
        view.colorPicker.dataSource = view
        view.colorPicker.delegate = view
        view.fontSizeStepper.value = view.size
        return view
    }
    
    // Pickers define only one value each
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // Number of pickerview rows according to number of options provided
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == fontPicker {
            fonts.count
        } else {
            colors.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == fontPicker {       // Font picker displays the name of font
            let label = UILabel()
            label.text = fonts[row]
            return label
        } else {       // Color picker displays the color itself
            let view = UILabel()
            view.backgroundColor = colors[row]
            return view
        }
    }
    
    // Passing user input to stored properies
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fontPicker {
            font = fonts[row]
        } else {
            color = colors[row]
        }
    }
    

}
