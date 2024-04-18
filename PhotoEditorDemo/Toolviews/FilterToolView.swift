//
//  FilterToolView.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit
import Localize_Swift

// Filter functions performed by MainViewController, view only passes signals
protocol FilterToolDelegate: AnyObject {
  func didChangeFilter(to filter: CIFilter?)
}

class FilterToolView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Collection for filter
    @IBOutlet weak var filterCollection: UICollectionView!
    
    // All the filters are stored in constants for easy editing
    let filters = Constants.Tools.filters

    // Create view from nib, basic collection configuration
    class func instanceFromNib() -> FilterToolView {
        let view = UINib(nibName: "FilterToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterToolView
        // Register standart cell for collection
        view.filterCollection.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "DefaultCell")
        return view
    }
    
    // Should be MainViewController
    weak var delegate: FilterToolDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number of cells according to the filters count
        filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Getting basic list cell, and setting it's text property
        let cell = filterCollection.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath) as! UICollectionViewListCell
        var content = cell.defaultContentConfiguration()
        // Text is just the filters name without the CI prefix
        content.text = filters[indexPath.row].replacingOccurrences(of: "CI", with: "").localized()
        cell.contentConfiguration = content
        return cell
    }
    
    // Passing the user input to delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didChangeFilter(to: CIFilter(name: filters[indexPath.row]))
    }
}
