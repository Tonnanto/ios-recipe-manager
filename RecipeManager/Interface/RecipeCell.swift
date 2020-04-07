//
//  RecipeCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 18.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeCell: BaseTableViewCell {
    
    var _target: MyRecipesViewController!
    var recipe: Recipe?
    
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryIndicatorView: CategoryIndicatorView!
    
    func setUpViews() {
        nameLabel.font = .preferredFont(forTextStyle: .title3)
        _imageView.layer.cornerRadius = 2
        categoryIndicatorView.setUpViews()
    }
    
    func fillData(recipe: Recipe) {
        self.recipe = recipe
        _imageView.image = recipe.imageArray.first ?? UIImage(named: "recipe_256_template")?.withRenderingMode(.alwaysTemplate)
        nameLabel.text = recipe.name
        categoryIndicatorView.fillData(recipe: recipe)
    }
    
    override func prepareForReuse() {
        self.recipe = nil
        _imageView.image = nil
        nameLabel.text = ""
    }
}
