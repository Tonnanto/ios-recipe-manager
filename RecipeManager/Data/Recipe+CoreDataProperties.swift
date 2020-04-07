//
//  Recipe+CoreDataProperties.swift
//  RecipeManager
//
//  Created by Anton Stamme on 15.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var modificationDate: Date?
    @NSManaged public var images: Data?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String
    @NSManaged public var tagsString: String
    @NSManaged public var infoString: String
    @NSManaged public var categoriesString: String
    @NSManaged public var recordName: String
    @NSManaged public var subRecipes: NSOrderedSet
    @NSManaged public var preperationSteps: NSOrderedSet

}

// MARK: Generated accessors for subRecipes
extension Recipe {

    @objc(insertObject:inSubRecipesAtIndex:)
    @NSManaged public func insertIntoSubRecipes(_ value: SubRecipe, at idx: Int)

    @objc(removeObjectFromSubRecipesAtIndex:)
    @NSManaged public func removeFromSubRecipes(at idx: Int)

    @objc(insertSubRecipes:atIndexes:)
    @NSManaged public func insertIntoSubRecipes(_ values: [SubRecipe], at indexes: NSIndexSet)

    @objc(removeSubRecipesAtIndexes:)
    @NSManaged public func removeFromSubRecipes(at indexes: NSIndexSet)

    @objc(replaceObjectInSubRecipesAtIndex:withObject:)
    @NSManaged public func replaceSubRecipes(at idx: Int, with value: SubRecipe)

    @objc(replaceSubRecipesAtIndexes:withSubRecipes:)
    @NSManaged public func replaceSubRecipes(at indexes: NSIndexSet, with values: [SubRecipe])

    @objc(addSubRecipesObject:)
    @NSManaged public func addToSubRecipes(_ value: SubRecipe)

    @objc(removeSubRecipesObject:)
    @NSManaged public func removeFromSubRecipes(_ value: SubRecipe)

    @objc(addSubRecipes:)
    @NSManaged public func addToSubRecipes(_ values: NSOrderedSet)

    @objc(removeSubRecipes:)
    @NSManaged public func removeFromSubRecipes(_ values: NSOrderedSet)

}

// MARK: Generated accessors for preperationSteps
extension Recipe {

    @objc(insertObject:inPreperationStepsAtIndex:)
    @NSManaged public func insertIntoPreperationSteps(_ value: PreperationStep, at idx: Int)

    @objc(removeObjectFromPreperationStepsAtIndex:)
    @NSManaged public func removeFromPreperationSteps(at idx: Int)

    @objc(insertPreperationSteps:atIndexes:)
    @NSManaged public func insertIntoPreperationSteps(_ values: [PreperationStep], at indexes: NSIndexSet)

    @objc(removePreperationStepsAtIndexes:)
    @NSManaged public func removeFromPreperationSteps(at indexes: NSIndexSet)

    @objc(replaceObjectInPreperationStepsAtIndex:withObject:)
    @NSManaged public func replacePreperationSteps(at idx: Int, with value: PreperationStep)

    @objc(replacePreperationStepsAtIndexes:withPreperationSteps:)
    @NSManaged public func replacePreperationSteps(at indexes: NSIndexSet, with values: [PreperationStep])

    @objc(addPreperationStepsObject:)
    @NSManaged public func addToPreperationSteps(_ value: PreperationStep)

    @objc(removePreperationStepsObject:)
    @NSManaged public func removeFromPreperationSteps(_ value: PreperationStep)

    @objc(addPreperationSteps:)
    @NSManaged public func addToPreperationSteps(_ values: NSOrderedSet)

    @objc(removePreperationSteps:)
    @NSManaged public func removeFromPreperationSteps(_ values: NSOrderedSet)

}
