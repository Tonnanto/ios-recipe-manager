//
//  RecipeDetailTitleCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailTitleCell: BaseCollectionViewCell {
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    var _target: RecipeDetailViewController!
    static var titleFont = UIFont.preferredFont(forTextStyle: .title1)//.systemFont(ofSize: 28, weight: .semibold)

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = RecipeDetailTitleCell.titleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = 0
        label.contentMode = .top
        return label
    }()
    
    var imageConfig = UIImage.SymbolConfiguration(pointSize: 28)
    lazy var favouriteButton: AnimatedButton = {
        let button = AnimatedButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.selectedTintColor = .systemPink
        button.unselectedTintColor = .label
        button.springDuration = 0.8
        button.initialSpringScale = 0.7
        button.springDampening = 0.3
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: imageConfig), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: imageConfig), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(handlefavouriteButton), for: .touchUpInside)
        return button
    }()
    
    override func setUpViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(favouriteButton)
        contentView.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: favouriteButton, attribute: .left, multiplier: 1, constant: -10),
        
            NSLayoutConstraint(item: favouriteButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: -2),
            NSLayoutConstraint(item: favouriteButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: favouriteButton, attribute: .height, relatedBy: .equal, toItem: favouriteButton, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: favouriteButton, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
        ])
    }
    
    func fillData() {
        favouriteButton.animate = false
        if let product = _target.recipe {
            titleLabel.text = product.name
        }
        favouriteButton.isSelected = _target.recipe?.isFavourite ?? false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.favouriteButton.animate = true
        }
    }
    
    @objc func handlefavouriteButton() {
        favouriteButton.isSelected = !favouriteButton.isSelected
        generator.impactOccurred()
        if let recipe = _target.recipe {
            if favouriteButton.isSelected {
                recipe.favourite()
            } else {
                recipe.unfavourite()
            }
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
}
