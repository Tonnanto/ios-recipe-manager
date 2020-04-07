//
//  CategoryIndicatorView.swift
//  RecipeManager
//
//  Created by Anton Stamme on 18.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class CategoryIndicatorView: UIView {
    
    var recipe: Recipe?
    lazy var categories: [Recipe.Category] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(CategoryIndicatorCell.self, forCellWithReuseIdentifier: "CategoryIndicatorCell")
        cv.backgroundColor = .clear
        cv.isUserInteractionEnabled = false
        return cv
    }()
    
    func setUpViews() {
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    func fillData(recipe: Recipe?) {
        self.recipe = recipe
        categories = recipe?.categoiesArr.sorted(by: {
            if Recipe.Category.allCategories.firstIndex(of: $0) ?? 0 < Recipe.Category.allCategories.firstIndex(of: $1) ?? 0 {
                return true
            }
            return false
        }) ?? []
        collectionView.reloadData()
    }
}

extension CategoryIndicatorView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.item]
        let width = bounds.height//selected ? bounds.height : bounds.height * 0.75
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryIndicatorCell", for: indexPath) as! CategoryIndicatorCell
        cell.background.backgroundColor = category.tintColor
        cell.imageView.image = category.icon32
        cell.background.layer.cornerRadius = width / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.item]
        let width = bounds.height//selected ? bounds.height : bounds.height * 0.8
        let height = bounds.height
        return CGSize(width: width, height: height)
    }
}

class CategoryIndicatorCell: BaseCollectionViewCell {
    
    lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .secondarySystemBackground
        return iv
    }()
    
    override func setUpViews() {
        contentView.addSubview(background)
        background.addSubview(imageView)
        
        background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        background.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        background.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        background.heightAnchor.constraint(equalTo: background.widthAnchor).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

    }
    
    override func prepareForReuse() {
        background.backgroundColor = .clear
        imageView.image = nil
        background.layer.cornerRadius = 0
    }
}
