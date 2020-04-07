//
//  NewRecipeDetailCategoriesCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 22.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeDetailCategoriesCell: BaseTableViewCell {
    var _target: NewRecipeDetailCell!
    
    var categories: [Recipe.Category] { return _target._target.recipeCategories.sorted(by: {
        if Recipe.Category.allCategories.firstIndex(of: $0) ?? 0 < Recipe.Category.allCategories.firstIndex(of: $1) ?? 0 {
            return true
        }
        return false
    })}
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(EditCategoriesCell.self, forCellWithReuseIdentifier: "EditCategoriesCell")
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 0, left: NewRecipeDetailCell.contentInset, bottom: 0, right: -NewRecipeDetailCell.contentInset)
        return cv
    }()
    
    func setUpViews() {
        contentView.addSubview(collectionView)
        contentView.addConstraints([
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func fillData() {
        
    }
}

extension NewRecipeDetailCategoriesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item != 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditCategoriesCell", for: indexPath) as! EditCategoriesCell
            return cell
        }
        let category = categories[indexPath.item - 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.selectable = false
        cell.titleLabel.textColor = .label
        cell.fillData(category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height * 0.8
        return CGSize(width: height * 0.8, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectCategoryViewController") as! SelectCategoryViewController
        vc._target = self
        _target._target.present(vc, animated: true, completion: nil)
    }
}

class EditCategoriesCell: BaseCollectionViewCell {
    
    lazy var editLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Edit", comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    override func setUpViews() {
        contentView.addSubview(editLabel)
        editLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        editLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}




