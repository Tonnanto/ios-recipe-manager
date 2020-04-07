//
//  CategoryFilterCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 18.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class CategoryFilterCell: BaseTableViewCell {
    
    var generator = UISelectionFeedbackGenerator()
    
    var showClearButton: Bool = false {
        didSet {
            if showClearButton {
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                })
            } else {
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
                })
            }
        }
    }
    
    var _target: MyRecipesViewController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setUpViews() {
//        separatorInset = UIEdgeInsets(top: 0, left: _target.tableView.bounds.width, bottom: 0, right: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    func fillData() {
        
    }
    
    
}

extension CategoryFilterCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard _target.selectedCategories.count == 0 else { return Recipe.Category.allCategories.count + 1 }
        return Recipe.Category.allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard _target.selectedCategories.count == 0 || indexPath.item != 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.setUpViews()
            cell.fillData(category: nil)
            return cell
        }
        
        let index = _target.selectedCategories.count == 0 ? indexPath.item : indexPath.item - 1

        let category = Recipe.Category.allCategories[index]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.setUpViews()
        cell.fillData(category: category)
        cell.isSelected = _target.selectedCategories.contains(category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height * 0.8, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.item != 0 || showClearButton == false else {
            _target.selectedCategories = []
            generator.selectionChanged()
            collectionView.indexPathsForSelectedItems?.forEach({path in collectionView.deselectItem(at: path, animated: true)})
            showClearButton = false
            return
        }
        
        var arr: [Recipe.Category] = []
        for path in collectionView.indexPathsForSelectedItems ?? [] {
            var item = path.item
            if showClearButton && item > 0 { item -= 1 }
            arr.append(Recipe.Category.allCategories[item])
        }
        
        generator.selectionChanged()
        self._target.selectedCategories = arr
        
        if showClearButton == false {
            showClearButton = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        var arr: [Recipe.Category] = []
        for path in collectionView.indexPathsForSelectedItems ?? [] {
            var item = path.item
            if showClearButton && item > 0 { item -= 1 }
            arr.append(Recipe.Category.allCategories[item])
        }
        
        _target.selectedCategories = arr
        generator.selectionChanged()
        
        if collectionView.numberOfItems(inSection: 0) > Recipe.Category.allCategories.count && _target.selectedCategories.count == 0 {
            showClearButton = false
        }
    }
}

class CategoryCell: BaseCollectionViewCell {
    
    var selectable: Bool = true
    override var isSelected: Bool {
        didSet {
            guard selectable else { return }
            selectedView.isHidden = !isSelected
            titleLabel.textColor = isSelected ? .label : .tertiaryLabel
        }
    }
    lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBackground
        return iv
    }()
    
    lazy var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.systemBackground.cgColor
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .tertiaryLabel
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    override func setUpViews() {
        contentView.addSubview(background)
        contentView.addSubview(titleLabel)
        background.addSubview(imageView)
        background.addSubview(selectedView)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: background, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: background, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 6),
            NSLayoutConstraint(item: background, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -6),
            NSLayoutConstraint(item: background, attribute: .height, relatedBy: .equal, toItem: background, attribute: .width, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: background, attribute: .bottom, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        background.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: background, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: background, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: background, attribute: .width, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: background, attribute: .height, multiplier: 0.5, constant: 0),

            NSLayoutConstraint(item: selectedView, attribute: .top, relatedBy: .equal, toItem: background, attribute: .top, multiplier: 1, constant: 3),
            NSLayoutConstraint(item: selectedView, attribute: .left, relatedBy: .equal, toItem: background, attribute: .left, multiplier: 1, constant: 3),
            NSLayoutConstraint(item: selectedView, attribute: .right, relatedBy: .equal, toItem: background, attribute: .right, multiplier: 1, constant: -3),
            NSLayoutConstraint(item: selectedView, attribute: .bottom, relatedBy: .equal, toItem: background, attribute: .bottom, multiplier: 1, constant: -3)
        ])
        
        let imageWidth = contentView.bounds.width - (12)
        background.layer.cornerRadius = imageWidth / 2
        selectedView.layer.cornerRadius = imageWidth / 2 - 3
    }
    
    func fillData(category: Recipe.Category?) {
        guard let category = category else {
            imageView.image = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            background.backgroundColor = .tertiaryLabel
            titleLabel.text = NSLocalizedString("Show All", comment: "")
            titleLabel.textColor = .secondaryLabel
            return
        }
        
        imageView.image = category.icon64
        background.backgroundColor = category.tintColor
        titleLabel.text = category.name
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        selectedView.layer.borderColor = UIColor.systemBackground.cgColor

    }
    
    override func prepareForReuse() {
        imageView.image = nil
        background.backgroundColor = .clear
        titleLabel.text = ""
        isSelected = false
        selectable = true
    }
}
