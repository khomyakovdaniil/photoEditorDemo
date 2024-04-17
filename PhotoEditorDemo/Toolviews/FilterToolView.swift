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
    
    var filters = ["CISepiaTone", "CIPixellate", "CIGaussianBlur", "CIComicEffect", "CIEdgeWork"]

    class func instanceFromNib() -> FilterToolView {
        return UINib(nibName: "FilterToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterToolView
    }
    
    weak var delegate: FilterToolDelegate?
    
    @IBAction func didSelectSepia(_ sender: Any) {
        let filterName = filters[0]
        delegate?.didChangeFilter(to: CIFilter(name: filterName)!)
    }
    
    @IBAction func didSelectPixel(_ sender: Any) {
        let filterName = filters[1]
        delegate?.didChangeFilter(to: CIFilter(name: filterName)!)
    }
    @IBAction func didSelectBlur(_ sender: Any) {
        let filterName = filters[2]
        delegate?.didChangeFilter(to: CIFilter(name: filterName)!)
    }
    @IBAction func didSelectComic(_ sender: Any) {
        let filterName = filters[3]
        delegate?.didChangeFilter(to: CIFilter(name: filterName)!)
    }
    @IBAction func didSelectEdgeWork(_ sender: Any) {
        let filterName = filters[4]
        delegate?.didChangeFilter(to: CIFilter(name: filterName)!)
    }
    
}
