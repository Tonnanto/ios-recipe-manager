//
//  PreperationStep+CoreDataProperties.swift
//  RecipeManager
//
//  Created by Anton Stamme on 15.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData


extension PreperationStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PreperationStep> {
        return NSFetchRequest<PreperationStep>(entityName: "PreperationStep")
    }

    @NSManaged public var text: String
    @NSManaged public var recipe: Recipe

}
