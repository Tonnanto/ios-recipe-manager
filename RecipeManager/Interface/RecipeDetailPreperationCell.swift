//
//  RecipeDetailPreperationCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailPreperationCell: BaseCollectionViewCell {
    
    var _target: RecipeDetailViewController!
    var recipe: Recipe? { return _target.recipe }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(named: "tint")
        label.text = NSLocalizedString("Preperation Steps", comment: "")
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()//frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(PreperationStepCell.self, forCellReuseIdentifier: "PreperationStepCell")
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        return tv
    }()
    
    override func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(fillData), name: RecipeDetailViewController.recipeUpdatedKey, object: nil)

        let seperator1 = RecipeDetailViewController.seperator()

        contentView.addSubview(seperator1)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tableView)

        contentView.addConstraints([
            NSLayoutConstraint(item: seperator1, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: seperator1, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: seperator1, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: seperator1, attribute: .bottom, multiplier: 1, constant: 24),
            NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28),
            
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 32),
            NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        ])
    }
    
    static func heightForRecipe(_ recipe: Recipe?, cvWidth: CGFloat) -> CGFloat {
        guard let recipe = recipe else { return 0 }
        var height: CGFloat = 160
        for step in recipe.preperationStepsArr {
            height += 140
            height += CGFloat(step.text.heightWithConstrainedWidth(width: cvWidth - (2 * RecipeDetailViewController.contentInset), font: PreperationStepCell.textFont))
        }
        return height
    }
    
    @objc func fillData() {
        tableView.reloadData()
    }
}

extension RecipeDetailPreperationCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe!.preperationStepsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prepStep = recipe!.preperationStepsArr[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreperationStepCell", for: indexPath) as! PreperationStepCell
        cell._target = self
        cell.setUpViews()
        cell.numberLabel.text = "\(indexPath.item + 1)"
        cell.fillData(step: prepStep)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let prepStep = recipe!.preperationStepsArr[indexPath.item]
        return 140 + prepStep.text.heightWithConstrainedWidth(width: tableView.bounds.width - (2 * RecipeDetailViewController.contentInset), font: PreperationStepCell.textFont)
    }
}


class PreperationStepCell: BaseTableViewCell {
    
    static var textFont = UIFont.systemFont(ofSize: 20, weight: .regular)
    
    var _target: RecipeDetailPreperationCell!
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "lightTint")
        label.textAlignment = .center
        label.textColor = UIColor(named: "heavyTint")
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    lazy var stepLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.font = PreperationStepCell.textFont
        label.numberOfLines = 0
        return label
    }()
    
    func setUpViews() {
        selectionStyle = .none
        
        let leftLine = RecipeDetailViewController.seperator()
        leftLine.backgroundColor = .tertiaryLabel
        
        let rightLine = RecipeDetailViewController.seperator()
        rightLine.backgroundColor = .tertiaryLabel
        
        contentView.addSubview(leftLine)
        contentView.addSubview(rightLine)
        contentView.addSubview(numberLabel)
        contentView.addSubview(stepLabel)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: leftLine, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: leftLine, attribute: .right, relatedBy: .equal, toItem: numberLabel, attribute: .left, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: leftLine, attribute: .centerY, relatedBy: .equal, toItem: numberLabel, attribute: .centerY, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: numberLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: numberLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: numberLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: numberLabel, attribute: .height, relatedBy: .equal, toItem: numberLabel, attribute: .width, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: rightLine, attribute: .left, relatedBy: .equal, toItem: numberLabel, attribute: .right, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: rightLine, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: rightLine, attribute: .centerY, relatedBy: .equal, toItem: numberLabel, attribute: .centerY, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: stepLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: stepLabel, attribute: .top, relatedBy: .equal, toItem: numberLabel, attribute: .bottom, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: stepLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -RecipeDetailViewController.contentInset),
            NSLayoutConstraint(item: stepLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -16)
        ])
        
        numberLabel.layer.cornerRadius = 25
        numberLabel.layer.masksToBounds = true
    }
    
    func fillData(step: PreperationStep) {
        stepLabel.text = step.text
    }
    
    override func prepareForReuse() {
        numberLabel.text = ""
        stepLabel.text = ""
    }
}
