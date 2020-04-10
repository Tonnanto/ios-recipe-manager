//
//  RecipeBooksCollectionViewCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 09.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeBooksCollectionViewCell: BaseCollectionViewCell {

    var _target: RecipeBooksViewController!
    
    lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOffset = CGSize(width: 1, height: 1)
        iv.layer.shadowRadius = 5
        iv.layer.shadowOpacity = 0.4
        return iv
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var recipeAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    
    
    override func setUpViews() {
        contentView.addSubview(iconView)
        contentView.addSubview(infoView)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: iconView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: iconView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: iconView, attribute: .bottom, relatedBy: .equal, toItem: infoView, attribute: .top, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: iconView, attribute: .width, multiplier: 1.1, constant: 0),
            
            NSLayoutConstraint(item: infoView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: infoView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
        infoView.addSubview(nameLabel)
        infoView.addSubview(recipeAmountLabel)
        infoView.addConstraints([
            NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: infoView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: infoView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28),
            NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: infoView, attribute: .top, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: recipeAmountLabel, attribute: .centerX, relatedBy: .equal, toItem: infoView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: recipeAmountLabel, attribute: .left, relatedBy: .equal, toItem: infoView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: recipeAmountLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: recipeAmountLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 0),
        ])
    }
    
    func fillData(recipeBook: RecipeBook) {
        iconView.image = recipeBook.icon
        nameLabel.text = recipeBook.name
        recipeAmountLabel.text = "\(recipeBook.recipesArr.count) \(NSLocalizedString("Recipes", comment: ""))"
    }
    
    override func prepareForReuse() {
        iconView.image = nil
        nameLabel.text = ""
        recipeAmountLabel.text = ""
    }
}
