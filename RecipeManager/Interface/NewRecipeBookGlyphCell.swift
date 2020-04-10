//
//  NewRecipeBookGlyphCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 10.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeBookGlyphCell: BaseTableViewCell {
    
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
        cv.decelerationRate = .fast
        cv.register(RecipeBookGlyphCell.self, forCellWithReuseIdentifier: "RecipeBookGlyphCell")
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

extension NewRecipeBookGlyphCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeBookGlyphs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let glyph = recipeBookGlyphs[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeBookGlyphCell", for: indexPath) as! RecipeBookGlyphCell
        cell.fillData(glyph: glyph, edge: (collectionView.bounds.height - 12) / 2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let edge = (collectionView.bounds.height - 12) / 2
        return CGSize(width: edge, height: edge)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let glyph = recipeBookGlyphs[indexPath.item]
        _target.recipeBookGlyph = glyph
        NotificationCenter.default.post(name: NewRecipeBookViewController.detailsChangedKey, object: nil)
    }
}

class RecipeBookGlyphCell: BaseCollectionViewCell {
    
    lazy var glyphView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setUpViews() {
        contentView.addSubview(glyphView)
        
        glyphView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        glyphView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        glyphView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        glyphView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    func fillData(glyph: UIImage?, edge: CGFloat) {
        glyphView.image = glyph
    }
    
    override func prepareForReuse() {
        glyphView.image = nil
    }
}
