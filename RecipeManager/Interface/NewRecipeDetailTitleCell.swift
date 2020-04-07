//
//  NewRecipeDetailTitleCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 21.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeDetailTitleCell: BaseTableViewCell {
    
    var _target: NewRecipeDetailCell!
    static var font = UIFont.systemFont(ofSize: 20, weight: .medium)
    
    lazy var textView: UITextView = {
        let tf = UITextView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = NewRecipeDetailTitleCell.font
        tf.textAlignment = .left
        tf.isScrollEnabled = false
        tf.placeholder = NSLocalizedString("Add a title...", comment: "")
        tf.backgroundColor = .clear
        tf.delegate = self
        return tf
    }()
    
    func setUpViews() {
        contentView.addSubview(textView)
        contentView.addConstraints([
            NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        textView.bounds = textView.bounds
    }
    
    func fillData() {
        textView.text = _target._target.recipeTitle
        textView.delegate?.textViewDidChange?(textView)
    }
}

extension NewRecipeDetailTitleCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.textViewDidChange(textView)
        _target._target.recipeTitle = textView.text
    }
}
