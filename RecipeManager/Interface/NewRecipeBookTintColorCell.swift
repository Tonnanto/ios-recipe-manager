//
//  NewRecipeBookTintColorCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 09.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeBookTintColorCell: BaseTableViewCell {
    
    var _target: NewRecipeBookViewController!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(RecipeBookColorCell.self, forCellWithReuseIdentifier: "RecipeBookColorCell")
        cv.decelerationRate = .fast
        return cv
    }()
    
    func setUpViews() {
        selectionStyle = .none
        contentView.addSubview(collectionView)
        
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    func fillData() {
        
    }
}

extension NewRecipeBookTintColorCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecipeBook.Color.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = RecipeBook.Color.allCases[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeBookColorCell", for: indexPath) as! RecipeBookColorCell
        cell.fillData(color: color, edge: (collectionView.bounds.height - 12) / 2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let edge = (collectionView.bounds.height - 12) / 2
        return CGSize(width: edge, height: edge)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = RecipeBook.Color.allCases[indexPath.item]
        _target.recipeBookColor = color
        NotificationCenter.default.post(name: NewRecipeBookViewController.detailsChangedKey, object: nil)
    }
}

class RecipeBookColorCell: BaseCollectionViewCell {
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setUpViews() {
        contentView.addSubview(colorView)
        
        colorView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        colorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        colorView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    func fillData(color: RecipeBook.Color, edge: CGFloat) {
        colorView.backgroundColor = color.color
        colorView.layer.cornerRadius = edge / 2
    }
    
    override func prepareForReuse() {
        colorView.backgroundColor = .clear
    }
}
