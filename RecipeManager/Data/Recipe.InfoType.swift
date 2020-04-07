//
//  Recipe.InfoType.swift
//  RecipeManager
//
//  Created by Anton Stamme on 27.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

extension Recipe {
    enum InfoType {
        case serves(_: Int16)
        case prepTime(_: Int16)
        case cookTime(_: Int16)
        case totalTime(_: Int16)
        case ovenTemp(_: Int16, unit: Character)
        case dateAdded(_: Date)
        
        var key: String {
            switch self {
            case .serves(_): return "serves"
            case .prepTime(_): return "prepTime"
            case .cookTime(_): return "cookTime"
            case .totalTime(_): return "totalTime"
            case .ovenTemp(_, unit: _): return "ovenTemp"
            case .dateAdded(_): return "dateAdded"
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .serves(_): return UIImage(named: "dishes_128")?.withRenderingMode(.alwaysTemplate)
            case .prepTime(_): return UIImage(named: "prepare_128")?.withRenderingMode(.alwaysTemplate)
            case .cookTime(_): return UIImage(named: "microwaveOpen_128")?.withRenderingMode(.alwaysTemplate)
            case .totalTime(_): return UIImage(named: "stopwatch_128")?.withRenderingMode(.alwaysTemplate)
            case .dateAdded(_): return UIImage(named: "")?.withRenderingMode(.alwaysTemplate)
            case .ovenTemp(_, _): return UIImage(named: "baking_128")?.withRenderingMode(.alwaysTemplate)
            }
        }
        
        var title: String {
            switch self {
            case .serves(_): return "serves"
            case .prepTime(_): return "prep time"
            case .cookTime(_): return "cook time"
            case .totalTime(_): return "total time"
            case .ovenTemp(_, unit: _): return "heat"
            case .dateAdded(_): return "date added"
            }
        }
        
        var value: String {
            switch self {
            case .serves(let i): return "\(i)"
            case .prepTime(let i): return "\(i) min"
            case .cookTime(let i): return "\(i) min"
            case .totalTime(let i): return "\(i) min"
            case .ovenTemp(let i, unit: let u): return "\(i) °\(u)"
            case .dateAdded(let i): return ""
            }
        }
        
        func toString() -> String { // "type,value"
            switch self {
            case .dateAdded(_), .totalTime(_): return ""
            case .ovenTemp(let i, unit: let u): return "\(key),\(i)\(u)"
            case .prepTime(let i), .cookTime(let i): return "\(key),\(i)"
            default: return "\(key),\(value)"
            }
        }
    }
        
    func infoStringToArray() -> [InfoType] { // "type,value;type,value;type,value" -> [InfoType]
        var infoArr = [InfoType]()
        var totalTimeTuple: (prepTime: Int?, cookTime: Int?) = (nil, nil)  // Add totalTime InfoType if prep && cookTime available
        let infos = self.infoString.split(separator: ";")
        for info in infos {
            let keyValue = info.split(separator: ",")
            guard keyValue.count == 2 else { continue }
            var key = keyValue[0], value = keyValue[1]
            switch key {
            case "serves": if let amount = String(value).integerValue { infoArr.append(.serves(Int16(amount))) }
            case "prepTime": if let amount = String(value).integerValue { totalTimeTuple.prepTime = amount; infoArr.append(.prepTime(Int16(amount))) }
            case "cookTime": if let amount = String(value).integerValue { totalTimeTuple.cookTime = amount; infoArr.append(.cookTime(Int16(amount))) }
            case "ovenTemp":
                guard let unitChar = value.popLast(), unitChar == "C" || unitChar == "F" else { break }
                if let heat = String(value).integerValue { infoArr.append(.ovenTemp(Int16(heat), unit: unitChar)) }
            default: break
            }
        }
        
        if let prepTime = totalTimeTuple.prepTime, let cookTime = totalTimeTuple.cookTime {
            infoArr.append(.totalTime(Int16(prepTime + cookTime)))
        }
        
        return infoArr
    }
}
