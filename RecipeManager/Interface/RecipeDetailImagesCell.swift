//
//  RecipeDetailImagesCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailImagesCell: BaseCollectionViewCell {
    
    var _target: RecipeDetailViewController!
    
    var imageInset: CGFloat { RecipeDetailViewController.contentInset }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.layer.masksToBounds = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(RecipeImageCell.self, forCellWithReuseIdentifier: "RecipeImageCell")

        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.pageIndicatorTintColor = UIColor(named: "tint")!.withAlphaComponent(0.5)
        control.currentPageIndicatorTintColor = UIColor(named: "tint")!
        control.isUserInteractionEnabled = false
        control.hidesForSinglePage = true
        return control
    }()
    
    override func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(fillData), name: RecipeDetailViewController.recipeUpdatedKey, object: nil)
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        contentView.addConstraints([
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageControl, attribute: .top, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: pageControl, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: imageInset),
            NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16)
            ])
    }
    
    @objc func fillData() {
        collectionView.reloadData()
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: 0)
        
        if let index = collectionView.indexPathForItem(at: collectionView.center)?.item {
            pageControl.currentPage = index
        }
    }
    
    override func prepareForReuse() {
        pageControl.numberOfPages = 0
    }
}

extension RecipeDetailImagesCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _target.recipe?.imageArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeImageCell", for: indexPath) as! RecipeImageCell
        let image = _target.recipe?.imageArray[indexPath.item]
        cell.imageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height - (2 * imageInset)
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = self.contentView.convert(self.collectionView.center, to: self.collectionView)
        if let index = collectionView.indexPathForItem(at: center)?.item, index != pageControl.currentPage {
            pageControl.currentPage = index
        }
    }
}


class RecipeImageCell: BaseCollectionViewCell {
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    lazy var imageView: ZoomableImageView = {
        let iv = ZoomableImageView(image: nil)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .secondarySystemBackground
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override func setUpViews() {
        contentView.addSubview(shadowView)
        contentView.addConstraints([
            NSLayoutConstraint(item: shadowView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shadowView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shadowView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: shadowView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
        ])
        
        shadowView.addSubview(imageView)
        shadowView.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: shadowView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: shadowView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: shadowView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: shadowView, attribute: .right, multiplier: 1, constant: 0),
        ])
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
