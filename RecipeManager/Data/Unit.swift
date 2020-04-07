//
//  Unit.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation

enum UnitType: CaseIterable {
    static var allCases: [UnitType] = [
        .none,

        .weight(.grams),
        .weight(.kilograms),
        .weight(.ounces),
        .weight(.pounds),
        
        .volume(.millilitres),
        .volume(.litres),
        .volume(.tablespoons),
        .volume(.teaspoons),
        .volume(.cups),
        .volume(.gallon),
        .volume(.fluidOunce),
        
        .sprinkle,
        
        .amount(.pieces),
        .amount(.slices),
        .amount(.custom(""))

    ]
    typealias AllCases = [UnitType]
    
    case volume(_ unit: VolumeUnit)
    case weight(_ unit: WeightUnit)
    case amount(_ unit: AmountUnit)
    case sprinkle // prise
    case none
    
    var key: String {
        switch self {
        case .volume(let unit): return unit.key
        case .weight(let unit): return unit.key
        case .amount(let unit): return unit.key
        case .sprinkle: return "sprinkle"
        case .none: return "none"
        }
    }
    
    var name: String {
        switch self {
        case .volume(let unit): return unit.name
        case .weight(let unit): return unit.name
        case .amount(let unit): return unit.name
        case .sprinkle: return NSLocalizedString("Sprinkle", comment: "")
        case .none: return "-"
        }
    }
    
    var short: String {
        switch self {
        case .volume(let unit): return unit.short
        case .weight(let unit): return unit.short
        case .amount(let unit): return unit.short
        case .sprinkle: return NSLocalizedString("Sprinkle", comment: "")
        case .none: return ""
        }
    }
    
    var fractions: Bool {
        switch self {
        case .volume(let unit): return unit.fractions
        case .weight(let unit): return unit.fractions
        case .amount(let unit): return unit.fractions
        default: return false
        }
    }
    
    func inOtherUnits(retarded: Bool, amount: Double) -> (unit: UnitType, amount: Double) {
        switch self {
        case .volume(let unit): return unit.inOtherUnits(retarded: retarded, amount: amount)
        case .weight(let unit): return unit.inOtherUnits(retarded: retarded, amount: amount)
        default: return (self, amount)
        }
    }
    
    static func unitForKey(_ key: String, andName name: String? = nil) -> UnitType {
        switch key {
        case "sprinkle": return .sprinkle
        case "tbsp": return .volume(.tablespoons)
        case "tsp": return .volume(.teaspoons)
        case "cups": return .volume(.cups)
        case "l": return .volume(.litres)
        case "ml": return .volume(.millilitres)
        case "gallon": return .volume(.gallon)
        case "fl.oz.": return .volume(.fluidOunce)
        case "g": return .weight(.grams)
        case "kg": return .weight(.kilograms)
        case "oz": return .weight(.ounces)
        case "lb": return .weight(.pounds)
        case "pcs": return .amount(.pieces)
        case "slices": return .amount(.slices)
        case "custom": if let name = name { return .amount(.custom(name)) } else { return .none }
        default: return .none
        }
    }
}

enum VolumeUnit {
    case tablespoons
    case teaspoons
    case cups
    case litres
    case millilitres
    case gallon
    case fluidOunce
    
    var key: String {
        switch self {
        case .tablespoons: return "tbsp"
        case .teaspoons: return "tsp"
        case .cups: return "cups"
        case .litres: return "l"
        case .millilitres: return "ml"
        case .gallon: return "gallon"
        case .fluidOunce: return "fl.oz."
        }
    }
    
    var name: String {
        switch self {
        case .tablespoons: return NSLocalizedString("Table Spoons", comment: "")
        case .teaspoons: return NSLocalizedString("Tea Spoons", comment: "")
        case .cups: return NSLocalizedString("Cups", comment: "")
        case .litres: return NSLocalizedString("Litre", comment: "")
        case .millilitres: return NSLocalizedString("Millilitre", comment: "")
        case .gallon: return NSLocalizedString("Gallon", comment: "")
        case .fluidOunce: return NSLocalizedString("Fluid Ounce", comment: "")
        }
    }
    var short: String {
        switch self {
        case .tablespoons: return NSLocalizedString("tbsp", comment: "")
        case .teaspoons: return NSLocalizedString("tsp", comment: "")
        case .cups: return NSLocalizedString("cups", comment: "")
        case .litres: return NSLocalizedString("l", comment: "")
        case .millilitres: return NSLocalizedString("ml", comment: "")
        case .gallon: return NSLocalizedString("gal", comment: "")
        case .fluidOunce: return NSLocalizedString("fl oz", comment: "")
        }
    }
    
    var fractions: Bool {
        switch self {
        case .tablespoons, .teaspoons, .cups, .gallon: return true
        default: return false
        }
    }
    
    func inOtherUnits(retarded: Bool, amount: Double) -> (unit: UnitType, amount: Double) {
        if retarded {
            switch self {
            case .litres: return (.volume(.fluidOunce), amount * 33.814)
            case .millilitres: return (.volume(.fluidOunce), amount * 0.033814)
            case .tablespoons:
                guard amount > 10 else { fallthrough }
                return (.volume(.fluidOunce), amount * 0.5)
            case .teaspoons:
                guard amount > 10 else { fallthrough }
                return (.volume(.fluidOunce), amount * 0.5 / 3)
            default: return (.volume(self), amount)
            }
            
        } else {
            switch self {
            case .cups: return (.volume(.millilitres), amount * 236.5882)
            case .gallon: return (.volume(.millilitres), amount * 3785.41)
            case .fluidOunce: return (.volume(.millilitres), amount * 29.57353)
            case .tablespoons:
                guard amount > 10 else { fallthrough }
                return (.volume(.millilitres), amount * 14.78677)
            case .teaspoons:
                guard amount > 10 else { fallthrough }
                return (.volume(.millilitres), amount * 4.92892)
            default: return (.volume(self), amount)
            }
        }
    }
}

enum WeightUnit {
    case grams
    case kilograms
    case ounces
    case pounds
    
    var key: String {
        switch self {
        case .grams: return "g"
        case .kilograms: return "kg"
        case .ounces: return "oz"
        case .pounds: return "lb"
        }
    }
    
    var name: String {
        switch self {
        case .grams: return NSLocalizedString("Gram", comment: "")
        case .kilograms: return NSLocalizedString("Kilogram", comment: "")
        case .ounces: return NSLocalizedString("Ounce", comment: "")
        case .pounds: return NSLocalizedString("Pound", comment: "")
        }
    }
    var short: String {
        switch self {
        case .grams: return NSLocalizedString("g", comment: "")
        case .kilograms: return NSLocalizedString("kg", comment: "")
        case .ounces: return NSLocalizedString("oz", comment: "")
        case .pounds: return NSLocalizedString("lb", comment: "")
        }
    }
    
    var fractions: Bool {
        switch self {
        case .ounces, .pounds: return true
        default: return false
        }
    }
    
    func inOtherUnits(retarded: Bool, amount: Double) -> (unit: UnitType, amount: Double) {
        if retarded {
            switch self {
            case .grams: return (.weight(.ounces), amount * 0.03527396)
            case .kilograms: return (.weight(.ounces), amount * 35.27396)
            default: return (.weight(self), amount)
            }
            
        } else {
            switch self {
            case .ounces: return (.weight(.grams), amount * 28.3495)
            case .pounds: return (.weight(.grams), amount * 453.592)
            default: return (.weight(self), amount)
            }
        }
    }
}

enum AmountUnit {
    case pieces
    case slices
    case custom(String)
    
    var key: String {
        switch self {
        case .pieces: return "pcs"
        case .slices: return "slices"
        case .custom: return "custom"
        }
    }
    
    var name: String {
        switch self {
        case .pieces: return NSLocalizedString("Pieces", comment: "")
        case .slices: return NSLocalizedString("Slices", comment: "")
        case .custom(let name): return name
        }
    }
    var short: String {
        switch self {
        case .pieces: return NSLocalizedString("pcs", comment: "")
        case .slices: return NSLocalizedString("Slices", comment: "")
        case .custom(let name): return name
        }
    }
    
    var fractions: Bool {
        return true
    }
}

enum TemperatureUnit: CaseIterable {
    case celsius
    case fahrenheit
    
    var key: String {
        switch self {
        case .celsius: return "celsius"
        case .fahrenheit: return "fahrenheit"
        }
    }
    
    var name: String {
        switch self {
        case .celsius: return "Celsius"
        case .fahrenheit: return "Fahrenheit"
        }
    }
    var short: Character {
        switch self {
        case .celsius: return "C"
        case .fahrenheit: return "F"
        }
    }
}
