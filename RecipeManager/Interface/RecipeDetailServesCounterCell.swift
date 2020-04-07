//
//  RecipeDetailServesCounterCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 15.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailServesCounterCell: BaseCollectionViewCell {
    
    let generator = UISelectionFeedbackGenerator()
    
    var _target: RecipeDetailViewController!
    var recipe: Recipe? { return _target.recipe }
    
    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "lightTint")
        button.tintColor = .label
        button.setImage(UIImage(systemName: "minus", withConfiguration: symbolConfig), for: .normal)
        button.addTarget(self, action: #selector(minus), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "lightTint")
        button.tintColor = .label
        button.setImage(UIImage(systemName: "plus", withConfiguration: symbolConfig), for: .normal)
        button.addTarget(self, action: #selector(plus), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "heavyTint")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    override func setUpViews() {
        let seperator1 = RecipeDetailViewController.seperator()

        contentView.addSubview(seperator1)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
        contentView.addSubview(valueLabel)
        
        let minimumLineSpacing: CGFloat = 16

        contentView.addConstraints([
            NSLayoutConstraint(item: seperator1, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: seperator1, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: seperator1, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: minusButton, attribute: .top, relatedBy: .equal, toItem: seperator1, attribute: .bottom, multiplier: 1, constant: minimumLineSpacing),
            NSLayoutConstraint(item: minusButton, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: minusButton, attribute: .width, relatedBy: .equal, toItem: plusButton, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: minusButton, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: valueLabel, attribute: .top, relatedBy: .equal, toItem: seperator1, attribute: .bottom, multiplier: 1, constant: minimumLineSpacing),
            NSLayoutConstraint(item: valueLabel, attribute: .left, relatedBy: .equal, toItem: minusButton, attribute: .right, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: valueLabel, attribute: .width, relatedBy: .equal, toItem: minusButton, attribute: .width, multiplier: 0.8, constant: 0),
            NSLayoutConstraint(item: valueLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),

            NSLayoutConstraint(item: plusButton, attribute: .top, relatedBy: .equal, toItem: seperator1, attribute: .bottom, multiplier: 1, constant: minimumLineSpacing),
            NSLayoutConstraint(item: plusButton, attribute: .left, relatedBy: .equal, toItem: valueLabel, attribute: .right, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: plusButton, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: plusButton, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func fillData() {
        valueLabel.text = "\(_target.currentDishAmount)"
    }
    
    @objc func minus() {
        generator.selectionChanged()
        if _target.currentDishAmount > 1 {
            _target.currentDishAmount -= 1
        }
    }
    
    @objc func plus() {
        generator.selectionChanged()
        _target.currentDishAmount += 1
    }
    
    override func prepareForReuse() {
        valueLabel.text = ""
    }
}
