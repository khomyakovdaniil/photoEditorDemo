//
//  FilterToolView.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit

protocol FilterToolDelegate: AnyObject {
  func didChangeFilter(to filter: CIFilter)
}

class FilterToolView: UIView {
    
    var filters = ["CISepiaTone", "CIPixellate", "CIGaussianBlur"]

    class func instanceFromNib() -> FilterToolView {
        return UINib(nibName: "FilterToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterToolView
    }
    
    weak var delegate: FilterToolDelegate?
    
    @IBAction func didSelectFilter(_ sender: UISegmentedControl) { // TODO: rewrite to buttons
        let filterName = filters[sender.selectedSegmentIndex]
        delegate?.didChangeFilter(to: CIFilter(name: filterName)!)
    }
    
}
