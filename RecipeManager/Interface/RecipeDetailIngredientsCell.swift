//
//  RecipeDetailIngredientsCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailIngredientsCell: BaseCollectionViewCell {
    
    static var rowHeight: CGFloat = 38
    static var headerHeight: CGFloat = 44

    var _target: RecipeDetailViewController!
    var recipe: Recipe? { return _target.recipe }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(named: "tint")
        label.text = NSLocalizedString("Ingredients", comment: "")
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(IngredientsCell.self, forCellReuseIdentifier: "IngredientsCell")
        tv.isScrollEnabled = false
        
        return tv
    }()
    
    override func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(fillData), name: RecipeDetailViewController.recipeUpdatedKey, object: nil)

        contentView.addSubview(titleLabel)
        contentView.addSubview(tableView)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28),
            
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    @objc func fillData() {
        tableView.reloadData()
    }
    
    static func heightForRecipe(_ recipe: Recipe?) -> CGFloat {
        guard let recipe = recipe else { return 0 }
        var height: CGFloat = headerHeight + 32
        for subRecipe in recipe.subRecipesArr {
            height += CGFloat(subRecipe.ingredients.count) * rowHeight
        }
        height += (headerHeight + 32) * CGFloat(recipe.subRecipesArr.count - 1)
        return height
    }
    
    override func prepareForReuse() {
        
    }
}


extension RecipeDetailIngredientsCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return _target.recipe?.subRecipesArr.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _target.recipe?.subRecipesArr[section].ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient = recipe!.subRecipesArr[indexPath.section].ingredients[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath) as! IngredientsCell
        cell._target = _target
        cell.setUpViews()
        cell.ingredient = ingredient
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else { return 0 }
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section != recipe!.subRecipesArr.count - 1 else { return 0 }
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section != recipe!.subRecipesArr.count - 1 else { return nil }
        return UIView()

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }
        let header = SubRecipeIngredientsHeader()
        header.setUpViews()
        header.titleLabel.text = recipe!.subRecipesArr[section].name
        return header
    }

    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecipeDetailIngredientsCell.rowHeight
    }
    
}

class IngredientsCell: BaseTableViewCell {
    
    var _target: RecipeDetailViewController!
    
    var ingredient: Ingredient? {
        didSet {
            amountLabel.text = ingredient?.amountStringForDishAmount(currentAmount: Double(_target.currentDishAmount))
            nameLabel.text = ingredient?.type.name
        }
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func setUpViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(amountLabel)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.6, constant: 0),
            
            NSLayoutConstraint(item: amountLabel, attribute: .left, relatedBy: .equal, toItem: nameLabel, attribute: .right, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: amountLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: amountLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: amountLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset)
        ])
    }
    
    override func prepareForReuse() {
        ingredient = nil
    }
}


class SubRecipeIngredientsHeader: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .light)
        label.textColor = UIColor(named: "tint")
        return label
    }()
    
    func setUpViews() {
        addSubview(titleLabel)
        
        addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
}
