//
//  SelectCategoyViewController.swift
//  RecipeManager
//
//  Created by Anton Stamme on 23.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import  UIKit

class SelectCategoryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var _target: NewRecipeDetailCategoriesCell!
    
    var generator = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    func setUpViews() {
        navigationItem.title = NSLocalizedString("Select Categories", comment: "")
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.allowsMultipleSelection = true
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoryHeaderView")
    }
    
    @IBAction func handleDoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    var indexPathsToSelect: [IndexPath] = []
    override func viewDidAppear(_ animated: Bool) {
        for indexPath in indexPathsToSelect {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _target.collectionView.reloadData()
    }
}

extension SelectCategoryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return Recipe.Category.primaryCategories.count }
        return Recipe.Category.secondaryCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = (indexPath.section == 0) ? Recipe.Category.primaryCategories[indexPath.item] : Recipe.Category.secondaryCategories[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        if _target.categories.contains(category) { cell.isSelected = true; collectionView.selectItem(at: indexPath, animated: false, scrollPosition: []) }// indexPathsToSelect.append(indexPath) }
        cell.fillData(category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoryHeaderView", for: indexPath) as! CategoryHeaderView

            headerView.setUpViews()
            headerView.titleLabel.text = (indexPath.section == 0) ? NSLocalizedString("Primary Categories", comment: "") : NSLocalizedString("Secondary Categories", comment: "")
            return headerView
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 84
        return CGSize(width: height * 0.8, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = (indexPath.section == 0) ? Recipe.Category.primaryCategories[indexPath.item] : Recipe.Category.secondaryCategories[indexPath.item]
        generator.selectionChanged()
        guard !_target.categories.contains(category) else {
            return
        }
        _target._target._target.recipeCategories.append(category)
        NotificationCenter.default.post(name: NewRecipeDetailCell.detailsChangedKey, object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let category = (indexPath.section == 0) ? Recipe.Category.primaryCategories[indexPath.item] : Recipe.Category.secondaryCategories[indexPath.item]
        generator.selectionChanged()
        guard _target.categories.contains(category) else {
            return
        }
        _target._target._target.recipeCategories.removeAll(where: {$0 == category})
        NotificationCenter.default.post(name: NewRecipeDetailCell.detailsChangedKey, object: nil)
    }
    
}


class CategoryHeaderView: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    func setUpViews() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
}
