//
//  NewRecipePreperationStepsCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 21.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipePreperationStepsCell: BaseCollectionViewCell {
    var _target: NewRecipeViewController!
    
    static var contentInset: CGFloat = 8
    static var orderUpdatedKey = NSNotification.Name("prepStepOrderUpdated")
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.keyboardDismissMode = .onDrag
        tv.register(NewRecipePreperationStepsPreperationStepCell.self, forCellReuseIdentifier: "NewRecipePreperationStepsPreperationStepCell")
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "NewRecipePreperationStepsAddPreperationStepCell")
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
        
    }
    
    @objc func toggleEditMode(_ button: UIButton) {
        button.isSelected = !button.isSelected
        tableView.setEditing(button.isSelected, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        let info = notification.userInfo
        
        if let keyboardRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var contentInset = tableView.contentInset
            contentInset.bottom = keyboardRect.size.height + 100
            tableView.contentInset = contentInset
            
            var indicatorInset = tableView.verticalScrollIndicatorInsets
            indicatorInset.bottom = keyboardRect.size.height + 100
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

    func updateNumbers() {
        NotificationCenter.default.post(name: NewRecipePreperationStepsCell.orderUpdatedKey, object: nil)
    }
    
    override func prepareForReuse() {
        tableView.setEditing(false, animated: false)
    }
}

extension NewRecipePreperationStepsCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _target.recipePreperationSteps.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.item != _target.recipePreperationSteps.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipePreperationStepsAddPreperationStepCell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Add Step", comment: "")
            cell.imageView?.image = UIImage(systemName: "plus.circle.fill")
            cell.imageView?.tintColor = .systemGreen
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.selectionStyle = .none
            return cell
        }
        
        let prepStep = _target.recipePreperationSteps[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipePreperationStepsPreperationStepCell", for: indexPath) as! NewRecipePreperationStepsPreperationStepCell
        cell._target = self
        cell.setUpViews()
        cell.fillData(preperationStep: prepStep)
        cell.numberLabel.text = "\(indexPath.item + 1)"
        cell.textView.placeholder = indexPath.item == 0 ? NSLocalizedString("First Step...", comment: "") : NSLocalizedString("Next Step...", comment: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.item == _target.recipePreperationSteps.count else { return 250 }
        return 55
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 0 else { return "" }
        return NSLocalizedString("Preperation Steps", comment: "")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else { return 50 }
        return 32
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if !view.subviews.contains(editButton) {
//            view.addSubview(editButton)
//            editButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26).isActive = true
//            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.item == _target.recipePreperationSteps.count else { return }
        _target.recipePreperationSteps.append(PreperationStep(context: PersistenceService.context))
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: IndexPath(item: indexPath.item + 1, section: indexPath.section), at: .bottom, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? NewRecipePreperationStepsPreperationStepCell {
            cell.textView.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _target.recipePreperationSteps.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } else if editingStyle == .insert {
            _target.recipePreperationSteps.append(PreperationStep(text: ""))
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        updateNumbers()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard indexPath.item == _target.recipePreperationSteps.count else { return .delete }
        return .none
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.item == _target.recipePreperationSteps.count else { return true }
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = _target.recipePreperationSteps[sourceIndexPath.item]
        _target.recipePreperationSteps.remove(at: sourceIndexPath.item)
        _target.recipePreperationSteps.insert(movedObject, at: destinationIndexPath.item)
        updateNumbers()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.item != _target.recipePreperationSteps.count else { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard proposedDestinationIndexPath.item != _target.recipePreperationSteps.count else {
            return IndexPath(item: proposedDestinationIndexPath.item - 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
}
