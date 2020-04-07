//
//  Ingredient+CoreDataProperties.swift
//  RecipeManager
//
//  Created by Anton Stamme on 15.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var amount: Double
    @NSManaged public var recipe: SubRecipe
    @NSManaged public var type: IngredientType

}
