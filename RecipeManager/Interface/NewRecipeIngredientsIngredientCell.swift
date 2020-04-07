//
//  NewRecipeIngredientsIngredientCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 23.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeIngredientsIngredientCell: BaseTableViewCell {
    var _target: NewRecipeIngredientsCell!
    
    var ingredient: Ingredient?
    
    var generator = UINotificationFeedbackGenerator()
    
    var allUnits: [UnitType] { return UnitType.allCases + customUnits }
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.placeholder = NSLocalizedString("Ingredient", comment: "")
        tf.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tf.adjustsFontSizeToFitWidth = true
        tf.tag = 0
        tf.delegate = self
        return tf
    }()
    
    lazy var amountTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        tf.placeholder = "0"
        tf.keyboardType = .decimalPad
        tf.textAlignment = .right
        tf.adjustsFontSizeToFitWidth = true
        tf.inputAccessoryView = textFieldAccessory
        tf.tag = 1
        tf.delegate = self
        return  tf
    }()
    
    lazy var unitTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        tf.backgroundColor = .tertiarySystemGroupedBackground
        tf.placeholder = NSLocalizedString("unit", comment: "")
        tf.textAlignment = .center
        tf.adjustsFontSizeToFitWidth = true
        tf.setContentHuggingPriority(.defaultLow, for: .horizontal)
        tf.inputView = unitPickerView
        tf.inputAccessoryView = pickerAccessory
        tf.adjustsFontSizeToFitWidth = true
        tf.minimumFontSize = 8
        return tf
    }()
    
    lazy var textFieldAccessory: UIToolbar = {
        let pa = UIToolbar()
        pa.translatesAutoresizingMaskIntoConstraints = false
        pa.barStyle = .default
        pa.isTranslucent = true
        pa.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleInputDoneButton))
        doneButton.tintColor = UIColor(named: "heavyTint")

        pa.items = [flexSpace, doneButton]
        return pa
    }()
    
    lazy var pickerAccessory: UIToolbar = {
        let pa = UIToolbar()
        pa.translatesAutoresizingMaskIntoConstraints = false
        pa.barStyle = .default
//        pa.barTintColor = unitPickerView.backgroundColor
        pa.isTranslucent = true
        pa.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Add Unit", comment: ""), style: .plain, target: self, action: #selector(handleAddUnitButton))
        cancelButton.tintColor = UIColor(named: "heavyTint")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleUnitDoneButton))
        doneButton.tintColor = UIColor(named: "heavyTint")

        pa.items = [cancelButton, flexSpace, doneButton]
        return pa
    }()
    
    lazy var unitPicker: UIPickerView = {
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.dataSource = self
        pv.delegate = self
        return pv
    }()
    
    lazy var unitPickerView: UIView = {
        
        let view = UIView()
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
//        pv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let lg = UILayoutGuide()
        
        view.addSubview(unitPicker)
        view.addLayoutGuide(lg)
        
        unitPicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        unitPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        unitPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        lg.heightAnchor.constraint(equalToConstant: UIApplication.shared.windows[0].safeAreaInsets.bottom).isActive = true
        lg.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        lg.topAnchor.constraint(equalTo: unitPicker.bottomAnchor).isActive = true
        lg.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lg.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        return view
    }()
    
    func setUpViews() {
        self.selectionStyle = .none
        contentView.addSubview(nameTextField)
        contentView.addSubview(amountTextField)
        contentView.addSubview(unitTextField)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: nameTextField, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: NewRecipeIngredientsCell.contentInset + 8),
            NSLayoutConstraint(item: nameTextField, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameTextField, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameTextField, attribute: .right, relatedBy: .equal, toItem: amountTextField, attribute: .left, multiplier: 1, constant: -NewRecipeIngredientsCell.contentInset),
            
            NSLayoutConstraint(item: amountTextField, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: amountTextField, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: amountTextField, attribute: .width, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .width, multiplier: 0.2, constant: 0),
            NSLayoutConstraint(item: amountTextField, attribute: .right, relatedBy: .equal, toItem: unitTextField, attribute: .left, multiplier: 1, constant: -NewRecipeIngredientsCell.contentInset),
            
            NSLayoutConstraint(item: unitTextField, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: unitTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28),
            NSLayoutConstraint(item: unitTextField, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.2, constant: 0),
            NSLayoutConstraint(item: unitTextField, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -NewRecipeIngredientsCell.contentInset)
        ])
        
        unitTextField.layer.cornerRadius = 14
        unitTextField.layer.masksToBounds = true
        
    }
    
    func fillData(ingredient: Ingredient) {
        self.ingredient = ingredient
        nameTextField.text = ingredient.type.name
        amountTextField.text = ingredient.amount == 0 ? "" : "\(ingredient.amount)"
        unitTextField.text = "\(ingredient.type.unit.short)"
    }
    
    override func prepareForReuse() {
        nameTextField.text = nil
        amountTextField.text = nil
        unitTextField.placeholder = NSLocalizedString("unit", comment: "")
        unitPicker.selectRow(0, inComponent: 0, animated: false)
    }
    
    @objc func handleUnitDoneButton() {
        unitTextField.resignFirstResponder()
    }
    
    @objc func handleAddUnitButton() {
        let alert = UIAlertController(title: NSLocalizedString("Custom Unit", comment: ""), message: NSLocalizedString("Add a custom unit. For instance an ingredient specific unit i.E. \"Clove\" for garlic.", comment: ""), preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        let doneAction = UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default) { (action) in
            let name = alert.textFields![0].text!
            let unit = UnitType.amount(.custom(name))
            var index = self.allUnits.count
            if let firstIndex = self.allUnits.firstIndex(where: {$0.name == name}) { // if unit already exists dont append new unit & select existing one
                index = firstIndex
            } else {
                customUnits.append(unit)
                self.unitPicker.reloadComponent(0)
            }
            self.unitPicker.selectRow(index, inComponent: 0, animated: true)
            self.unitPicker.delegate?.pickerView?(self.unitPicker, didSelectRow: index, inComponent: 0)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)

        _target._target.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleInputDoneButton() {
        amountTextField.resignFirstResponder()
    }
    
    func updateIngredient() {
        
    }
}

extension NewRecipeIngredientsIngredientCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allUnits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allUnits[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let unit = allUnits[row]
        unitTextField.text = unit.short
        ingredient?.type.unit = unit
    }
}

extension NewRecipeIngredientsIngredientCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0: // name
            ingredient?.type.name = textField.text ?? ""
        case 1: // amount
            if let amount = textField.text?.doubleValue {
                ingredient?.amount = amount
            } else {
                if textField.text != "" && textField.text != nil { generator.notificationOccurred(.error) }
                textField.text = ""
            }
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _target.handleReturnKeyForCell(self)
        return false
    }
}
