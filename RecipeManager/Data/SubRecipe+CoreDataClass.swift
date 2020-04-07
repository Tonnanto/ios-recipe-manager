//
//  SubRecipe+CoreDataClass.swift
//  RecipeManager
//
//  Created by Anton Stamme on 15.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

@objc(SubRecipe)
public class SubRecipe: NSManagedObject {
    
    var record: CKRecord?

    var ingredients: [Ingredient] {
        return ingredientList?.array as? [Ingredient] ?? []
    }
    
    init(name: String, index: Int, ingredients: [Ingredient]) {
        super.init(entity: SubRecipe.entity(), insertInto: PersistenceService.context)
        self.name = name
        if self.name == "main" { self.index = 0 }
        else { self.index = Int16(index) }
        for ingredient in ingredients { self.addToIngredientList(ingredient) }
    }
    
    init?(record: CKRecord, completionHandler: @escaping(SubRecipe) -> Void) throws {
        super.init(entity: SubRecipe.entity(), insertInto: PersistenceService.context)
        self.record = record
        
        guard let name = record.value(forKey: "name") as? String else {
            throw Recipe.RecipeSaveError.dataMissing(missing: "SubRecipe.name") }
        guard let index = record.value(forKey: "index") as? Int16 else {
            throw Recipe.RecipeSaveError.dataMissing(missing: "SubRecipe.index") }

        self.name = name
        print(index)
        self.index = index

        let queue2 = CloudKitService.queue2
        
        // Ingredients
        queue2.async {
            CloudKitService.fetchReferences(withKey: "subRecipe", andRecordType: "Ingredients", forSourceRecordID: record.recordID) { (ingredientRecords)  in
                                
                print("fetching Ingredients completed")
                
                let group = DispatchGroup()
                
                for ingredient in ingredientRecords {
                    
                    do {
                        group.enter()
                        let _ = try Ingredient(record: ingredient) { (ingredient) in
                            ingredient.recipe = self
                            self.addToIngredientList(ingredient)
                            group.leave()
                            
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    
                    print("Successfully created new SubRecipe Obj: \(record.recordID.recordName)")
                    completionHandler(self)
                }
            }
        }
    }
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
}
