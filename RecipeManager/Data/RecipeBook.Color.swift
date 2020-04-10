//
//  RecipeBook.Color.swift
//  RecipeManager
//
//  Created by Anton Stamme on 10.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

extension RecipeBook {
    enum Color: CaseIterable {
        case salmon, cantaloupe, banana, honeydew, flora, spindrift, ice, sky, orchid, lavender, bubblegum, carnation
//
//        var name: String {
//            switch self {
//            case .salmon: return NSLocalizedString("salmon", comment: "")
//            case .blue: return "blue"
//            }
//        }
        
        var key: String {
            switch self {
            case .salmon: return "salmon"
            case .cantaloupe: return "cantaloupe"
            case .banana: return "banana"
            case .honeydew: return "honeydew"
            case .flora: return "flora"
            case .spindrift: return "spindrift"
            case .ice: return "ice"
            case .sky: return "sky"
            case .orchid: return "orchid"
            case .lavender: return "lavender"
            case .bubblegum: return "bubblegum"
            case .carnation: return "carnation"
            }
        }
        
        var color: UIColor {
            switch self {
            case .salmon: return UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
            case .cantaloupe: return UIColor(red: 255/255, green: 212/255, blue: 121/255, alpha: 1)
            case .banana: return UIColor(red: 255/255, green: 252/255, blue: 121/255, alpha: 1)
            case .honeydew: return UIColor(red: 212/255, green: 251/255, blue: 121/255, alpha: 1)
            case .flora: return UIColor(red: 115/255, green: 250/255, blue: 121/255, alpha: 1)
            case .spindrift: return UIColor(red: 115/255, green: 252/255, blue: 214/255, alpha: 1)
            case .ice: return UIColor(red: 115/255, green: 253/255, blue: 255/255, alpha: 1)
            case .sky: return UIColor(red: 118/255, green: 214/255, blue: 255/255, alpha: 1)
            case .orchid: return UIColor(red: 122/255, green: 129/255, blue: 255/255, alpha: 1)
            case .lavender: return UIColor(red: 215/255, green: 131/255, blue: 255/255, alpha: 1)
            case .bubblegum: return UIColor(red: 255/255, green: 133/255, blue: 255/255, alpha: 1)
            case .carnation: return UIColor(red: 255/255, green: 138/255, blue: 216/255, alpha: 1)
            }
        }
        
        var icon512: UIImage? {
            return UIImage(named: "recipeBook_\(key)")
        }
        
        static func colorForKey(_ key: String) -> Color {
            return allCases.first(where: {$0.key == key}) ?? .salmon
        }
        static func randomColor() -> Color {
            return allCases.randomElement() ?? .salmon
        }
    }
}
