//
//  NewRecipeIngredientsCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 21.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeIngredientsCell: BaseCollectionViewCell {
    var _target: NewRecipeViewController!
    
    static var contentInset: CGFloat = 8
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.keyboardDismissMode = .onDrag
        tv.register(NewRecipeIngredientsIngredientCell.self, forCellReuseIdentifier: "NewRecipeIngredientsIngredientCell")
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "NewRecipeIngredientsAddIngredientCell")
        tv.allowsSelectionDuringEditing = true
        return tv
    }()
    
//    lazy var editButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
//        button.setTitle(NSLocalizedString("Done", comment: ""), for: .selected)
//        button.setTitleColor(.systemBlue, for: .normal)
//        button.addTarget(self, action: #selector(toggleEditMode(_:)), for: .touchUpInside)
//        return button
//    }()
    
    override func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        contentView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    func fillData() {
//        tableView.setEditing(true, animated: true)

    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        let info = notification.userInfo
        
        if let keyboardRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var contentInset = tableView.contentInset
            contentInset.bottom = keyboardRect.size.height + 22
            tableView.contentInset = contentInset
            
            var indicatorInset = tableView.verticalScrollIndicatorInsets
            indicatorInset.bottom = keyboardRect.size.height + 22
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
    
    static func newIngredient() -> Ingredient {
        let newIngredient = Ingredient(context: PersistenceService.context)
        newIngredient.type = IngredientType(context: PersistenceService.context)
        return newIngredient
    }
    
    func handleReturnKeyForCell(_ cell: NewRecipeIngredientsIngredientCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if let nextCell = tableView.cellForRow(at: nextIndexPath) as? NewRecipeIngredientsIngredientCell {
                nextCell.nameTextField.becomeFirstResponder()
            } else {
                addIngredientCellTapped(at: nextIndexPath)
            }
        }
    }
    
    override func prepareForReuse() {
        tableView.setEditing(false, animated: false)
    }
}

extension NewRecipeIngredientsCell: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return _target.recipeIngredients.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section != _target.recipeIngredients.count else { return 1 }
        return _target.recipeIngredients[section].ingredients.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Add List Cell
        guard indexPath.section != _target.recipeIngredients.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeIngredientsAddIngredientCell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Add List", comment: "")
            cell.imageView?.image = UIImage(systemName: "plus.circle.fill")
            cell.imageView?.tintColor = .systemGreen
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.selectionStyle = .none
            return cell
        }
        // Add Ingredient Cell
        guard indexPath.item != _target.recipeIngredients[indexPath.section].ingredients.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeIngredientsAddIngredientCell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Add Ingredient", comment: "")
            cell.imageView?.image = UIImage(systemName: "plus.circle.fill")
            cell.imageView?.tintColor = .systemGreen
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.selectionStyle = .none
            return cell
        }
        
        let ingredient = _target.recipeIngredients[indexPath.section].ingredients[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeIngredientsIngredientCell", for: indexPath) as! NewRecipeIngredientsIngredientCell
        cell._target = self
        cell.setUpViews()
        cell.fillData(ingredient: ingredient)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else { return 50 }
        return 32
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if section == 0 && !view.subviews.contains(editButton) {
//            view.addSubview(editButton)
//            editButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
//            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        }
//    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section != _target.recipeIngredients.count else { return " " }
        guard section != 0 else { return NSLocalizedString("Main Ingredients", comment: "") }
        return _target.recipeIngredients[section].name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Add Ingredient List Cell
        guard indexPath.section != _target.recipeIngredients.count else {
            addListCellTapped(at: indexPath)
            return
        }
        
        // Add Ingredient Cell
        guard indexPath.item != _target.recipeIngredients[indexPath.section].ingredients.count else {
            addIngredientCellTapped(at: indexPath)
            return
        }
    }
    
    func addIngredientCellTapped(at indexPath: IndexPath) {
        _target.recipeIngredients[indexPath.section].ingredients.append(NewRecipeIngredientsCell.newIngredient())
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: IndexPath(item: indexPath.item + 1, section: indexPath.section), at: .bottom, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? NewRecipeIngredientsIngredientCell {
            cell.nameTextField.becomeFirstResponder()
        }
    }
    
    func addListCellTapped(at indexPath: IndexPath) {
        let alert = UIAlertController(title: NSLocalizedString("New Ingredient List", comment: ""), message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Name (i.E. \"Sauce\")", comment: "")
        }
        let doneAction = UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default) { (action) in

            self._target.recipeIngredients.append((alert.textFields![0].text!, [NewRecipeIngredientsCell.newIngredient()]))
            self.tableView.insertSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
            self.tableView.scrollToRow(at: IndexPath(item: 0, section: indexPath.section + 1), at: .bottom, animated: true)
            if let cell = self.tableView.cellForRow(at: indexPath) as? NewRecipeIngredientsIngredientCell {
                cell.nameTextField.becomeFirstResponder()
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)

        _target.present(alert, animated: true, completion: nil)
    }
    
    func deleteList(at section: Int) {
        _target.recipeIngredients.remove(at: section)
        tableView.deleteSections(IndexSet(arrayLiteral: section), with: .automatic)
    }
     
    
    // EDITING ROWS
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section != _target.recipeIngredients.count, indexPath.item != _target.recipeIngredients[indexPath.section].ingredients.count else {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard indexPath.section != _target.recipeIngredients.count, indexPath.item != _target.recipeIngredients[indexPath.section].ingredients.count else {
            return .insert
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _target.recipeIngredients[indexPath.section].ingredients.remove(at: indexPath.item)
            
            // Remove Section if no ingredients left
            if indexPath.section != 0, _target.recipeIngredients[indexPath.section].ingredients.count == 0 {
                deleteList(at: indexPath.section)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            
            
        } else if editingStyle == .insert {
            // Add Ingredient List Cell
            guard indexPath.section != _target.recipeIngredients.count else {
                addListCellTapped(at: indexPath)
                return
            }
            
            // Add Ingredient Cell
            guard indexPath.item != _target.recipeIngredients[indexPath.section].ingredients.count else {
                addIngredientCellTapped(at: indexPath)
                return
            }
        }
    }
    
    
    // MOVEING ROWS
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = _target.recipeIngredients[sourceIndexPath.section].ingredients[sourceIndexPath.item]
        _target.recipeIngredients[sourceIndexPath.section].ingredients.remove(at: sourceIndexPath.item)
        _target.recipeIngredients[destinationIndexPath.section].ingredients.insert(movedObject, at: destinationIndexPath.item)
        
//        // Remove Section if no ingredients left
//        if sourceIndexPath.section != 0, _target.recipeIngredients[sourceIndexPath.section].ingredients.count == 0 {
//            deleteList(at: sourceIndexPath.section)
//        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section != _target.recipeIngredients.count, indexPath.item != _target.recipeIngredients[indexPath.section].ingredients.count else { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let sameSection = proposedDestinationIndexPath.section == sourceIndexPath.section
        guard proposedDestinationIndexPath.section != _target.recipeIngredients.count else {
            let goesInSameSection = proposedDestinationIndexPath.section - 1 == sourceIndexPath.section
            return IndexPath(item: _target.recipeIngredients[proposedDestinationIndexPath.section - 1].ingredients.count - ((goesInSameSection) ? 1 : 0), section: proposedDestinationIndexPath.section - 1)
        }
        guard proposedDestinationIndexPath.item != _target.recipeIngredients[proposedDestinationIndexPath.section].ingredients.count + ((sameSection) ? 0 : 1) else {
            return IndexPath(item: proposedDestinationIndexPath.item - 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
}
