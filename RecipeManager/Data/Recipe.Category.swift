//
//  Recipe.Category.swift
//  RecipeManager
//
//  Created by Anton Stamme on 18.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

extension Recipe {
    enum Category {
        case cooking, baking, grill, meal, pastries, snack, seasoning, dessert, sauce, drink, thermomix, vegetarian, vegan, sidedish, breakfast
        
        static var allCategories: [Category] { return primaryCategories + secondaryCategories }
        static var primaryCategories: [Category] = [.cooking, .baking, .grill]
        static var secondaryCategories: [Category] = [.meal, .sidedish, .snack, .dessert, .breakfast, .pastries, .seasoning, .sauce, .drink, .thermomix, .vegetarian, .vegan]
        
        var name: String {
            switch self {
            case .cooking: return NSLocalizedString("Cooking", comment: "")
            case .baking: return NSLocalizedString("Baking", comment: "")
            case .grill: return NSLocalizedString("Grill", comment: "")
            case .meal: return NSLocalizedString("Meal", comment: "")
            case .pastries: return NSLocalizedString("Pastries", comment: "")
            case .snack: return NSLocalizedString("Snack", comment: "")
            case .seasoning: return NSLocalizedString("Seasoning / Salt", comment: "")
            case .dessert: return NSLocalizedString("Dessert", comment: "")
            case .sauce: return NSLocalizedString("Dips / Sauces", comment: "")
            case .drink: return NSLocalizedString("Drink", comment: "")
            case .thermomix: return NSLocalizedString("Thermomix", comment: "")
            case .vegetarian: return NSLocalizedString("Vegetarian", comment: "")
            case .vegan: return NSLocalizedString("Vegan", comment: "")
            case .sidedish: return NSLocalizedString("Side Dish", comment: "")
            case .breakfast: return NSLocalizedString("Breakfast", comment: "")
            }
        }
        
        var key: String {
            switch self {
            case .cooking: return "cooking"
            case .baking: return "baking"
            case .grill: return "grill"
            case .meal: return "meal"
            case .pastries: return "pastries"
            case .snack: return "snack"
            case .seasoning: return "seasoning"
            case .dessert: return "dessert"
            case .sauce: return "sauce"
            case .drink: return "drink"
            case .thermomix: return "thermomix"
            case .vegetarian: return "vegetarian"
            case .vegan: return "vegan"
            case .sidedish: return "sidedish"
            case .breakfast: return "breakfast"
            }
        }
        
        var icon16: UIImage? {
            return UIImage(named: "\(key)_16")
        }
        
        var icon32: UIImage? {
            return UIImage(named: "\(key)_32")
        }
        
        var icon64: UIImage? {
            return UIImage(named: "\(key)_64")
        }
        
        var icon128: UIImage? {
            return UIImage(named: "\(key)_128")
        }
        
        var tintColor: UIColor? {
            switch self {
            case .cooking: return UIColor(named: "tint")
            case .baking: return .systemOrange
            case .grill: return .systemBlue
            default: return .secondaryLabel
            }
        }
        
        static func categoryForKey(_ key: String) -> Category? {
            switch key {
            case "cooking": return .cooking
            case "baking": return .baking
            case "grill": return .grill
            case "meal": return .meal
            case "pastries": return .pastries
            case "snack": return .snack
            case "seasoning": return .seasoning
            case "dessert": return .dessert
            case "sauce": return .sauce
            case "drink": return .drink
            case "thermomix": return .thermomix
            case "vegetarian": return .vegetarian
            case "vegan": return .vegan
            case "sidedish": return .sidedish
            case "breakfast": return .breakfast
            default: return nil
            }
        }
    }
}
