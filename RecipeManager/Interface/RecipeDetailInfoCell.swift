//
//  RecipeDetailInfoCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailInfoCell: BaseCollectionViewCell {
 
    var _target: RecipeDetailViewController!
    
    var infoTypes: [Recipe.InfoType]? { return _target.recipe?.infoArray }
    
    static var infoCellHeight: CGFloat = 50
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(InfoCell.self, forCellWithReuseIdentifier: "InfoCell")
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var dateAddedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    
    override func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(fillData), name: RecipeDetailViewController.recipeUpdatedKey, object: nil)
        contentView.addSubview(collectionView)
        contentView.addSubview(dateAddedLabel)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: dateAddedLabel, attribute: .top, multiplier: 1, constant: -6),
            
            NSLayoutConstraint(item: dateAddedLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: dateAddedLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: dateAddedLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: dateAddedLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12)
        ])
        

    }
    
    @objc func fillData() {
        collectionView.reloadData()
        if let creationDate = _target.recipe?.creationDate {
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            dateAddedLabel.text = "\(NSLocalizedString("Added", comment: "")): \(formatter1.string(from: creationDate))"
        }

    }
    
    override func prepareForReuse() {
        dateAddedLabel.text = ""
    }
    
    static func heightForNumberOfItems(_ number: Int) -> CGFloat {
        return CGFloat((number + 1) / 2) * (8 + RecipeDetailInfoCell.infoCellHeight) + 20
    }
}

extension RecipeDetailInfoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoTypes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let info = infoTypes![indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCell", for: indexPath) as! InfoCell
        cell.titleLabel.text = info.title
        cell.valueLabel.text = info.value
        cell.imageView.image = info.icon
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: RecipeDetailInfoCell.infoCellHeight)
    }
    
    
}


class InfoCell: BaseCollectionViewCell {
    var infoType: Recipe.InfoType? {
        didSet {
            imageView.image = infoType?.icon
            titleLabel.text = infoType?.title
            valueLabel.text = infoType?.value
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .light)
        label.textColor = UIColor(named: "tint")
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 4
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        return stack
    }()

    override func setUpViews() {
        addSubview(stack)
        addSubview(valueLabel)
        
        titleLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        addConstraints([
            NSLayoutConstraint(item: stack, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stack, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stack, attribute: .right, relatedBy: .equal, toItem: valueLabel, attribute: .left, multiplier: 1, constant: 0),

            NSLayoutConstraint(item: valueLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: valueLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: valueLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: valueLabel, attribute: .width, relatedBy: .equal, toItem: stack, attribute: .width, multiplier: 1.2, constant: 0)

        ])
    }
}
