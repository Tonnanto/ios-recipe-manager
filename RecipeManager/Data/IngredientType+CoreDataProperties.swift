//
//  IngredientType+CoreDataProperties.swift
//  RecipeManager
//
//  Created by Anton Stamme on 15.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData


extension IngredientType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientType> {
        return NSFetchRequest<IngredientType>(entityName: "IngredientType")
    }

    @NSManaged public var name: String
    @NSManaged public var unitString: String
    @NSManaged public var unitName: String
}
