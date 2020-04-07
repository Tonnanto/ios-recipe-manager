//
//  SubRecipe+CoreDataProperties.swift
//  RecipeManager
//
//  Created by Anton Stamme on 15.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData


extension SubRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubRecipe> {
        return NSFetchRequest<SubRecipe>(entityName: "SubRecipe")
    }

    @NSManaged public var index: Int16
    @NSManaged public var name: String
    @NSManaged public var ingredientList: NSOrderedSet?
    @NSManaged public var recipe: Recipe

}

// MARK: Generated accessors for ingredientList
extension SubRecipe {

    @objc(insertObject:inIngredientListAtIndex:)
    @NSManaged public func insertIntoIngredientList(_ value: Ingredient, at idx: Int)

    @objc(removeObjectFromIngredientListAtIndex:)
    @NSManaged public func removeFromIngredientList(at idx: Int)

    @objc(insertIngredientList:atIndexes:)
    @NSManaged public func insertIntoIngredientList(_ values: [Ingredient], at indexes: NSIndexSet)

    @objc(removeIngredientListAtIndexes:)
    @NSManaged public func removeFromIngredientList(at indexes: NSIndexSet)

    @objc(replaceObjectInIngredientListAtIndex:withObject:)
    @NSManaged public func replaceIngredientList(at idx: Int, with value: Ingredient)

    @objc(replaceIngredientListAtIndexes:withIngredientList:)
    @NSManaged public func replaceIngredientList(at indexes: NSIndexSet, with values: [Ingredient])

    @objc(addIngredientListObject:)
    @NSManaged public func addToIngredientList(_ value: Ingredient)

    @objc(removeIngredientListObject:)
    @NSManaged public func removeFromIngredientList(_ value: Ingredient)

    @objc(addIngredientList:)
    @NSManaged public func addToIngredientList(_ values: NSOrderedSet)

    @objc(removeIngredientList:)
    @NSManaged public func removeFromIngredientList(_ values: NSOrderedSet)

}
