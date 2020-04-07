//
//  NewRecipeDetailCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 21.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeDetailCell: BaseCollectionViewCell {
    
    static var contentInset: CGFloat = 8
    static var detailsChangedKey = Notification.Name("NewRecipeDetailCell.detailChanged")
    
    var _target: NewRecipeViewController!
    
    var generator = UINotificationFeedbackGenerator()
    
    var sections: [ContentType] = [.title, .images, .categories, .details]
    
    var possibleInfoTypes: [Recipe.InfoType] {
        var arr: [Recipe.InfoType] = [.serves(0), .prepTime(0), .cookTime(0)]
        if _target.recipeCategories.contains(where: {$0.key == "baking"}) { arr.append(.ovenTemp(0, unit: "C")) }
        return arr
    }
    
    enum ContentType: String {
        case images = "Images"
        case title = "Title"
        case categories = "Categories"
        case details = "Details"
        case delete = ""
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(NewRecipeDetailImagesCell.self, forCellReuseIdentifier: "NewRecipeDetailImagesCell")
        tv.register(NewRecipeDetailTitleCell.self, forCellReuseIdentifier: "NewRecipeDetailTitleCell")
        tv.register(NewRecipeDetailCategoriesCell.self, forCellReuseIdentifier: "NewRecipeDetailCategoriesCell")
        tv.register(NewRecipeDetailDetailsCell.self, forCellReuseIdentifier: "NewRecipeDetailDetailsCell")
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "NewRecipeDetailDeleteCell")
        tv.keyboardDismissMode = .onDrag
        tv.allowsSelection = true
        return tv
    }()
    
    override func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(detailsChanged), name: NewRecipeDetailCell.detailsChangedKey, object: nil)

        
        contentView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    func fillData() {
        if _target.editingRecipe != nil {
            sections.append(.delete)
            tableView.reloadData()
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        let info = notification.userInfo
        
        if let keyboardRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var contentInset = tableView.contentInset
            contentInset.bottom = keyboardRect.size.height + 12
            tableView.contentInset = contentInset
            
            var indicatorInset = tableView.verticalScrollIndicatorInsets
            indicatorInset.bottom = keyboardRect.size.height + 12
            tableView.scrollIndicatorInsets = indicatorInset
        }
    }
    
    @objc func keyboardWillHide() {
        var contentInset = tableView.contentInset
        contentInset.bottom = 0
        tableView.contentInset = contentInset

        var indicatorInset = tableView.verticalScrollIndicatorInsets
        indicatorInset.bottom = 0
        tableView.scrollIndicatorInsets = indicatorInset
    }
    
    @objc func detailsChanged() {
        if let section = sections.firstIndex(of: .details) {
            tableView.reloadSections([section], with: .automatic)
        }
    }
}

extension NewRecipeDetailCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let content = sections[section]
        switch content {
        case .details: return possibleInfoTypes.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = sections[indexPath.section]
        switch content {
        case .images:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeDetailImagesCell", for: indexPath) as! NewRecipeDetailImagesCell
            cell.selectionStyle = .none
            cell._target = self
            cell.setUpViews()
            cell.fillData()
            return cell
            
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeDetailTitleCell", for: indexPath) as! NewRecipeDetailTitleCell
            cell.selectionStyle = .none
            cell._target = self
            cell.setUpViews()
            cell.fillData()
            return cell
            
        case .categories:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeDetailCategoriesCell", for: indexPath) as! NewRecipeDetailCategoriesCell
            cell.selectionStyle = .none
            cell._target = self
            cell.setUpViews()
            cell.fillData()
            return cell
            
        case .details:
            var detail = possibleInfoTypes[indexPath.item]
            if let editingDetail = _target.recipeInfoTypes.first(where: {$0.key == detail.key}) { detail = editingDetail }
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeDetailDetailsCell", for: indexPath) as! NewRecipeDetailDetailsCell
            cell.selectionStyle = .none
            cell._target = self
            cell.setUpViews()
            cell.fillData(detail: detail)
            return cell
            
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeDetailDeleteCell", for: indexPath)
            cell.selectionStyle = .default
            cell.textLabel?.text = NSLocalizedString("Delete Recipe", comment: "")
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString(sections[section].rawValue, comment: "")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else { return 50 }
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = sections[indexPath.section]
        switch content {
        case .images: return 100
        case .title: return 100
        case .categories: return 96
        case .details: return 45
        default: return 55
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = sections[indexPath.section]
        switch content {

        case .delete:
            guard let recipe = _target.editingRecipe else { break }
            let alert = UIAlertController(title: NSLocalizedString("Delete Recipe", comment: ""), message: NSLocalizedString("Are you sure you want to delete this recipe? It will also be removed from the cloud.", comment: ""), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { (action) in
                recipes.removeAll(where: {$0.recordName == recipe.recordName})
                CloudKitService.deleteRecipeFromCloud(recipe: recipe) { (success, recordID) in
                    if success {
                        print("Successfully deleted Recipe from Cloud: \(recordID?.recordName ?? "")")
                        PersistenceService.persistentContainer.viewContext.delete(recipe)
                        PersistenceService.saveContext()
                    }
                }
                self._target.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            _target.present(alert, animated: true, completion: nil)
        default: break
        }
    }
}
