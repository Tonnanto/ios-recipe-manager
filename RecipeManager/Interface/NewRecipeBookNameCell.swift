//
//  NewRecipeBookNameCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 09.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeBookNameCell: BaseTableViewCell {
    
    var _target: NewRecipeBookViewController!

    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        tf.placeholder = "Name..."
        tf.clearButtonMode = .always
        tf.delegate = self
        return tf
    }()
    
    func setUpViews() {
        selectionStyle = .none
        contentView.addSubview(textField)
        
        textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        textField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    func fillData() {
        textField.text = _target.recipeBookName
    }
    
    override func prepareForReuse() {
        textField.text = ""
    }
}


extension NewRecipeBookNameCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        _target.recipeBookName = textField.text ?? ""
    }
}
