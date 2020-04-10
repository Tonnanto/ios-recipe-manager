//
//  NewRecipeBookIconCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 09.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeBookIconCell: BaseTableViewCell {
    
    var _target: NewRecipeBookViewController!
    
    lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    func setUpViews() {
        selectionStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(fillData), name: NewRecipeBookViewController.detailsChangedKey, object: nil)
        
        contentView.addSubview(iconView)
        iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
    }
    
    @objc func fillData() {
        iconView.image = _target.recipeBookIcon
    }
    
    override func prepareForReuse() {
        iconView.image = nil
    }
}
