//
//  RecipeBook+CoreDataProperties.swift
//  RecipeManager
//
//  Created by Anton Stamme on 10.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData


extension RecipeBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeBook> {
        return NSFetchRequest<RecipeBook>(entityName: "RecipeBook")
    }

    @NSManaged public var name: String
    @NSManaged public var recordName: String
    @NSManaged public var appearenceString: String
    @NSManaged public var imageData: Data?
    @NSManaged public var recipes: NSOrderedSet

}

// MARK: Generated accessors for recipes
extension RecipeBook {

    @objc(insertObject:inRecipesAtIndex:)
    @NSManaged public func insertIntoRecipes(_ value: Recipe, at idx: Int)

    @objc(removeObjectFromRecipesAtIndex:)
    @NSManaged public func removeFromRecipes(at idx: Int)

    @objc(insertRecipes:atIndexes:)
    @NSManaged public func insertIntoRecipes(_ values: [Recipe], at indexes: NSIndexSet)

    @objc(removeRecipesAtIndexes:)
    @NSManaged public func removeFromRecipes(at indexes: NSIndexSet)

    @objc(replaceObjectInRecipesAtIndex:withObject:)
    @NSManaged public func replaceRecipes(at idx: Int, with value: Recipe)

    @objc(replaceRecipesAtIndexes:withRecipes:)
    @NSManaged public func replaceRecipes(at indexes: NSIndexSet, with values: [Recipe])

    @objc(addRecipesObject:)
    @NSManaged public func addToRecipes(_ value: Recipe)

    @objc(removeRecipesObject:)
    @NSManaged public func removeFromRecipes(_ value: Recipe)

    @objc(addRecipes:)
    @NSManaged public func addToRecipes(_ values: NSOrderedSet)

    @objc(removeRecipes:)
    @NSManaged public func removeFromRecipes(_ values: NSOrderedSet)

}
