//
//  NewRecipePreperationStepsPreperationStepCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 24.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipePreperationStepsPreperationStepCell: BaseTableViewCell {
    var _target: NewRecipePreperationStepsCell!
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "lightTint")
        label.textAlignment = .center
        label.textColor = UIColor(named: "heavyTint")
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    lazy var textView: UITextView = {
        let tf = UITextView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textAlignment = .left
        tf.isScrollEnabled = false
        tf.placeholder = NSLocalizedString("Next Step...", comment: "")
        tf.backgroundColor = .clear
        tf.delegate = self
        return tf
    }()
    
    var preperationStep: PreperationStep?
    
    func setUpViews() {
        self.selectionStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(orderUpdated), name: NewRecipePreperationStepsCell.orderUpdatedKey, object: nil)

        let leftLine = RecipeDetailViewController.seperator()
        leftLine.backgroundColor = .clear//tertiaryLabel
        
        let rightLine = RecipeDetailViewController.seperator()
        rightLine.backgroundColor = .clear//tertiaryLabel
        
        contentView.addSubview(leftLine)
        contentView.addSubview(rightLine)
        contentView.addSubview(numberLabel)
        contentView.addSubview(textView)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: leftLine, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: NewRecipePreperationStepsCell.contentInset),
            NSLayoutConstraint(item: leftLine, attribute: .right, relatedBy: .equal, toItem: numberLabel, attribute: .left, multiplier: 1, constant: -NewRecipePreperationStepsCell.contentInset),
            NSLayoutConstraint(item: leftLine, attribute: .centerY, relatedBy: .equal, toItem: numberLabel, attribute: .centerY, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: numberLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: numberLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: numberLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: numberLabel, attribute: .height, relatedBy: .equal, toItem: numberLabel, attribute: .width, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: rightLine, attribute: .left, relatedBy: .equal, toItem: numberLabel, attribute: .right, multiplier: 1, constant: NewRecipePreperationStepsCell.contentInset),
            NSLayoutConstraint(item: rightLine, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -NewRecipePreperationStepsCell.contentInset),
            NSLayoutConstraint(item: rightLine, attribute: .centerY, relatedBy: .equal, toItem: numberLabel, attribute: .centerY, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: NewRecipePreperationStepsCell.contentInset),
            NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: numberLabel, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: textView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -NewRecipePreperationStepsCell.contentInset),
            NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -8)
        ])
        
        numberLabel.layer.cornerRadius = 20
        numberLabel.layer.masksToBounds = true

    }
    
    func fillData(preperationStep: PreperationStep) {
        self.preperationStep = preperationStep
        
        textView.text = preperationStep.text
        textView.delegate?.textViewDidChange?(textView)
    }
    
    @objc func orderUpdated() {
        if let prepStep = preperationStep, let index = _target._target.recipePreperationSteps.firstIndex(of: prepStep) {
            numberLabel.text = "\(index + 1)"
        }
    }
    
    override func prepareForReuse() {
        isEditing = false
    }
}


extension NewRecipePreperationStepsPreperationStepCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.textViewDidChange(textView)
        preperationStep?.text = textView.text
    }
}
