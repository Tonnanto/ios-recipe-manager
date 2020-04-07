//
//  NewRecipeDetailDetailsCell.swift
//  RecipeManager
//
//  Created by Anton Stamme on 23.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit


class NewRecipeDetailDetailsCell: BaseTableViewCell {
    var _target: NewRecipeDetailCell!
    
    var value: Int = 0
    
    var detail: Recipe.InfoType?
    
    lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        return iv
    }()
        
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    lazy var valueTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.keyboardType = .numberPad
        tf.inputAccessoryView = textFieldAccessory
        tf.delegate = self
        return tf
    }()
    
    lazy var unitTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        tf.backgroundColor = .tertiarySystemGroupedBackground
        tf.placeholder = "unit"
        tf.textAlignment = .center
        tf.adjustsFontSizeToFitWidth = true
        tf.setContentHuggingPriority(.defaultLow, for: .horizontal)
        tf.inputView = unitPickerView
        tf.inputAccessoryView = textFieldAccessory
        tf.adjustsFontSizeToFitWidth = true
        tf.minimumFontSize = 8
        tf.isHidden = true
        tf.isUserInteractionEnabled = false
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
        contentView.addSubview(iconView)
        contentView.addSubview(valueTextField)
        contentView.addSubview(unitTextField)
        contentView.addConstraints([
            NSLayoutConstraint(item: iconView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: NewRecipeDetailCell.contentInset),
            NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 0.8, constant: 0),
            NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: iconView, attribute: .height, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: valueTextField, attribute: .left, relatedBy: .equal, toItem: iconView, attribute: .right, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: valueTextField, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: valueTextField, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: valueTextField, attribute: .right, relatedBy: .equal, toItem: unitTextField, attribute: .left, multiplier: 1, constant: -NewRecipeDetailCell.contentInset),
            
            NSLayoutConstraint(item: unitTextField, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: unitTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28),
            NSLayoutConstraint(item: unitTextField, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.2, constant: 0),
            NSLayoutConstraint(item: unitTextField, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -NewRecipeDetailCell.contentInset)
        ])
        
        unitTextField.layer.cornerRadius = 14
        unitTextField.layer.masksToBounds = true
    }
    
    func fillData(detail: Recipe.InfoType) {
        self.detail = detail
        valueTextField.placeholder = detail.title
        iconView.image = detail.icon
        switch detail {
        case .serves(let i):
            if i != 0 { valueTextField.text = "\(i)" }
        case .cookTime(let i):
            unitTextField.isHidden = false
            unitTextField.text = "min"
            if i != 0 { valueTextField.text = "\(i)" }
        case .prepTime(let i):
            unitTextField.isHidden = false
            unitTextField.text = "min"
            if i != 0 { valueTextField.text = "\(i)" }
        case .ovenTemp(let i, unit: let u):
            unitTextField.isHidden = false
            unitTextField.isUserInteractionEnabled = true
            if let index = TemperatureUnit.allCases.firstIndex(where: {$0.short == u}) {
                unitPicker.selectRow(index, inComponent: 0, animated: false)
                unitPicker.delegate?.pickerView?(unitPicker, didSelectRow: index, inComponent: 0)
            }
            if i != 0 { valueTextField.text = "\(i)" }
        default: break
        }
    }
    
    @objc func handleInputDoneButton() {
        unitTextField.resignFirstResponder()
        valueTextField.resignFirstResponder()
    }
    
    override func prepareForReuse() {
        detail = nil
        valueTextField.text = ""
        iconView.image = nil
        unitTextField.text = ""
        unitTextField.isHidden = true
        unitTextField.isUserInteractionEnabled = false
    }
}

extension NewRecipeDetailDetailsCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let detail = detail else { return }
        var newDetail: Recipe.InfoType?
        switch detail {
        case .serves(let i):
            if let newValue = textField.text?.integerValue {
                _target._target.recipeInfoTypes.removeAll(where: {$0.key == "serves"})
                newDetail = .serves(Int16(newValue))
            } else if textField.text != "" && textField.text != nil {
                _target.generator.notificationOccurred(.error)
                textField.text = "\(i)"
            } else {
                _target._target.recipeInfoTypes.removeAll(where: {$0.key == "serves"})
            }
            
        case .cookTime(let i):
            if let newValue = textField.text?.integerValue {
                _target._target.recipeInfoTypes.removeAll(where: {$0.key == "cookTime"})
                newDetail = .cookTime(Int16(newValue))
            } else if textField.text != "" && textField.text != nil {
                _target.generator.notificationOccurred(.error)
                textField.text = "\(i)"
            } else {
                _target._target.recipeInfoTypes.removeAll(where: {$0.key == "cookTime"})
            }
            
        case .prepTime(let i):
            if let newValue = textField.text?.integerValue {
                _target._target.recipeInfoTypes.removeAll(where: {$0.key == "prepTime"})
                newDetail = .prepTime(Int16(newValue))
            } else if textField.text != "" && textField.text != nil {
                _target.generator.notificationOccurred(.error)
                textField.text = "\(i)"
            } else {
                _target._target.recipeInfoTypes.removeAll(where: {$0.key == "prepTime"})
            }
            
        case .ovenTemp(let i, unit: let u):
            if let newValue = textField.text?.integerValue {
                _target._target.recipeInfoTypes.removeAll(where: {$0.key == "ovenTemp"})
                newDetail = .ovenTemp(Int16(newValue), unit: u)
            } else if textField.text != "" && textField.text != nil {
                _target.generator.notificationOccurred(.error)
                textField.text = "\(i)"
            } else {
                _target._target.recipeInfoTypes.removeAll(where: {$0.key == "ovenTemp"})
            }
            
        default: break
        }
        
        if let newDetail = newDetail {
            _target._target.recipeInfoTypes.append(newDetail)
        }
    }
}

extension NewRecipeDetailDetailsCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let detail = detail else { return 0 }
        switch detail {
        case .ovenTemp(_, unit: _): return TemperatureUnit.allCases.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let detail = detail else { return "" }
        switch detail {
        case .ovenTemp(_, unit: _): return "°\(TemperatureUnit.allCases[row].short)"
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let detail = detail else { return }
        var newDetail: Recipe.InfoType?
        switch detail {
        case .ovenTemp(let i, unit: _):
            let unit = TemperatureUnit.allCases[row]
            _target._target.recipeInfoTypes.removeAll(where: {$0.key == "ovenTemp"})
            newDetail = .ovenTemp(i, unit: unit.short)
            unitTextField.text = "°\(unit.short)"
        default: break
        }
        
        if let newDetail = newDetail {
            _target._target.recipeInfoTypes.append(newDetail)
        }
    }
}
