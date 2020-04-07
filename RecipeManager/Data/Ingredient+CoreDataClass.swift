//
//  Ingredient+CoreDataClass.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Ingredient)
public class Ingredient: NSManagedObject {
    
    init(type: IngredientType, amount: Double) {
        super.init(entity: Ingredient.entity(), insertInto: PersistenceService.context)
        self.type = type
        self.amount = amount
    }
    
    init?(record: CKRecord, completionHandler: @escaping(Ingredient) -> Void) throws {
        super.init(entity: Ingredient.entity(), insertInto: PersistenceService.context)
        
        guard let name = record.value(forKey: "name") as? String else {
        throw Recipe.RecipeSaveError.dataMissing(missing: "SubRecipe.Ingredient.name") }
        guard let unitKey = record.value(forKey: "unitKey") as? String else {
            throw Recipe.RecipeSaveError.dataMissing(missing: "SubRecipe.Ingredient.unitKey") }
        guard let amount = record.value(forKey: "amount") as? Double else {
            throw Recipe.RecipeSaveError.dataMissing(missing: "SubRecipe.amount") }

        let unitName = record.value(forKey: "unitName") as? String
        let unit = UnitType.unitForKey(unitKey, andName: unitName)
        
        let ingredientType = IngredientType(name: name, unit: unit)
        self.type = ingredientType
        self.amount = amount
        
        print("Successfully created new Ingredient Obj: \(name) \(amount)")
        completionHandler(self)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    typealias Rational = (num: Int, den: Int)
    
    func amountStringForDishAmount(currentAmount: Double) -> String {
        guard currentAmount != 0 && amount != 0 else { return "" }
        
        var value = amount * currentAmount

        if let defaultDishAmount = recipe.recipe.defaultDishAmount {
            value /= Double(defaultDishAmount)
        }
        
        var unit = type.unit
        
        guard unit.key != "none" else { return "" }
        // Transform between Metric and Retarded
        let useRetardedUnits = UserDefaults.standard.bool(forKey: MoreItem.useRetardedUnitsKey)
        (unit, value) = unit.inOtherUnits(retarded: useRetardedUnits, amount: value)
        
        // Transform to a more appropriate unit (g -> kg)
        switch unit {
        case .volume(let i):
            switch i {
            case .millilitres:  if value > 1000 { unit = .volume(.litres); value /= 1000 }
            case .litres:       if value < 1 { unit = .volume(.millilitres); value *= 1000 }
            default: break
            }
            
        case .weight(let i):
            switch i {
            case .grams:        if value > 1000 { unit = .weight(.kilograms); value /= 1000 }
            case .kilograms:    if value < 1 { unit = .weight(.grams); value *= 1000 }
            default: break
            }
            
        default: break
        }
        
        // Right Way to display (0.5, 1/2, 1)
        if value.truncatingRemainder(dividingBy: 1) != 0 {  // Fraction
            if unit.fractions {
                let x0 = Double(Int(8 * value.truncatingRemainder(dividingBy: 1))) / 8
                if x0.truncatingRemainder(dividingBy: 1) == 0 {
                    return "\(value.format(f: zeroDecimal)) \(unit.short)"
                } else {
                    let rational = rationalApproximationOf(x0: x0)
                    return "\(Int(value) > 0 ? "\(Int(value))  " : "" )\(rational.num)/\(rational.den) \(unit.short)"
                }
            } else {   // Decimal
                
                // get number of Decimals (max 3 Digits)
                var numberOfDecimals: String = twoDecimal
                switch "\(Int(value))".count {
                case 2: numberOfDecimals = oneDecimal
                case 3: numberOfDecimals = zeroDecimal
                default: break
                }
                return "\(value.format(f: numberOfDecimals)) \(unit.short)"
            }
            
        } else {  // Int
            return "\(value.format(f: zeroDecimal)) \(unit.short)"
        }
        
    }
    
    func rationalApproximationOf(x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)

        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
}
