//
//  IngredientType+CoreDataClass.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(IngredientType)
public class IngredientType: NSManagedObject {
    
    var unit: UnitType {
        get {
            switch self.unitString {
            case "none": return .none
            case "sprinkle": return .sprinkle
            case "tbsp": return .volume(.tablespoons)
            case "tsp": return .volume(.teaspoons)
            case "cups": return .volume(.cups)
            case "l": return .volume(.litres)
            case "ml": return .volume(.millilitres)
            case "gallon": return .volume(.gallon)
            case "g": return .weight(.grams)
            case "kg": return .weight(.kilograms)
            case "oz": return .weight(.ounces)
            case "lb": return .weight(.pounds)
            case "pcs": return .amount(.pieces)
            case "slices": return .amount(.slices)
            case "custom": return .amount(.custom(self.unitName))
            default: return .none
            }
        }
        set {
            self.unitString = newValue.key
            switch newValue {
            case .amount(let unit):
                switch unit {
                case .custom(let unitName): self.unitName = unitName
                default: self.unitName = "" }
            default: self.unitName = "" }
        }
    }
    
    var icon128: UIImage? {
        return UIImage(named: "\(name.lowercased())_128")
    }
    var icon512: UIImage? {
        return UIImage(named: "\(name)_512")
    }

    init(name: String, unit: UnitType) {
        super.init(entity: IngredientType.entity(), insertInto: PersistenceService.context)
        self.name = name
        self.unit = unit
        updateCustomUnits()
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        updateCustomUnits()
    }
    
    static func initializeIngredientTypes() {
        
    }
    
    func updateCustomUnits() {
        if unitName != "" {
            if !customUnits.contains(where: {$0.name == unitName}) {
                customUnits.append(unit)
            }
        }
    }
}
