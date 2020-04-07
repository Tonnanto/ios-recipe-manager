//
//  RecipeDetailCategoriesCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 19.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailCategoriesCell: BaseCollectionViewCell {
    
    var _target: RecipeDetailViewController!
    var recipe: Recipe? { return _target.recipe }
    lazy var categories: [Recipe.Category] = []

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        cv.backgroundColor = .clear
        cv.isUserInteractionEnabled = false
        return cv
    }()
    
    override func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(fillData), name: RecipeDetailViewController.recipeUpdatedKey, object: nil)
        contentView.addSubview(collectionView)
        contentView.addConstraints([
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset)
        ])
    }
    
    @objc func fillData() {
        categories = recipe?.categoiesArr.sorted(by: {
            if Recipe.Category.allCategories.firstIndex(of: $0) ?? 0 < Recipe.Category.allCategories.firstIndex(of: $1) ?? 0 {
                return true
            }
            return false
        }) ?? []
        collectionView.reloadData()
    }
}

extension RecipeDetailCategoriesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.setUpViews()
        cell.fillData(category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height * 0.8, height: height)
    }
}
