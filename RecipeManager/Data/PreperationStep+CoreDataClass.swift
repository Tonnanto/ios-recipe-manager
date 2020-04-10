//
//  PreperationStep+CoreDataClass.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PreperationStep)
public class PreperationStep: NSManagedObject {

    init(text: String) {
        super.init(entity: PreperationStep.entity(), insertInto: PersistenceService.context)
        self.text = text
    }
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
