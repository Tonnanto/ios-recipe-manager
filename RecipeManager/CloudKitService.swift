//
//  CloudKitService.swift
//  RecipeManager
//
//  Created by Anton Stamme on 19.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class CloudKitService {
    static let container = CKContainer.init(identifier: "iCloud.RecipeManager")
    
    static let publicDB = container.publicCloudDatabase
    static let privateDB = container.privateCloudDatabase
    static let sharedDB = container.sharedCloudDatabase
    
    static let queue1 = DispatchQueue(label: "queue1", qos: .userInitiated)
    static let queue2 = DispatchQueue(label: "queue2", qos: .userInitiated)
    static let queue3 = DispatchQueue(label: "queue3", qos: .userInitiated)
    
    static let publicRecipesSubscriptionID = "CloudKit-Recipe-Changes"
    static let privateRecipesSubscriptionID = ""
    
    static func downloadAllRecipesFromCloud(completionHandler: @escaping([CKRecord]) -> Void) { // Gets Records of all Recipes in public DB
        let query = CKQuery(recordType: "Recipe", predicate: NSPredicate(value: true))
        
        print("Trying to query Recipes...")
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            guard records != nil else { print("0 Recipes found")
                return }
            
            print("\(records!.count) Recipes found!")

            if let error = error {
                print(error)
            }
            completionHandler(records!)
        }
    }
    
    static func createRecipeObjects(records: [CKRecord]) { // Creates  Recipe Objects from downloaded CKRecords
        for record in records {
            
            guard let subRecipeReferences = record.value(forKey: "subRecipes") as? [CKRecord.Reference] else {
                continue
            }
            
            let group = DispatchGroup()
            var subRecipes: [SubRecipe] = []
            
            for subRecipeReference in subRecipeReferences {
                group.enter()
                fetchReference(reference: subRecipeReference) { (subRecipeRecord) in
                    print("fetching SubRecipe Record completed")
                    do {
                        let _ = try SubRecipe(record: subRecipeRecord) { (subRecipe) in
                            subRecipes.append(subRecipe)
                            group.leave()
                        }
                        
                    } catch {
                        group.leave()
                        print(error.localizedDescription)
                    }
                    
                    
                }
            }
            

            group.notify(queue: .main) {
                do {
                    let recipe = try Recipe(record: record, subRecipes: subRecipes) { (recipe) in
                        recipes.append(recipe)
                        print("Successfully created new Recipe Obj: \(recipe.name)")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
     
    static func overwriteRecipeObjects(records: [CKRecord]) { //  Overwrites  Recipe Objects from downloaded CKRecords
        for record in records {
            guard let recipe = recipes.first(where: {$0.recordName == record.recordID.recordName}) else { continue }
            recipe.syncToRecord(record) { (success, numberOfChanges) in
                guard success else { print("Failed to sync Recipe to Record: \(recipe.name)"); return }
                print("Successfully synced Recipe to Record: \(recipe.name)")
                PersistenceService.saveContext()

            }
        }
    }
    
    static func checkForChanges(records: [CKRecord]) -> (new: [CKRecord], changed: [CKRecord]) { // Finds Recipes that have changes
        var newArr = [CKRecord]()
        var changedArr = [CKRecord]()
        for record in records {
            let recordName = record.recordID.recordName
            if let recipe = recipes.first(where: {$0.recordName == recordName}) {
                if recipe.modificationDate != record.modificationDate || (record.value(forKey: "subRecipes") as? [CKRecord.Reference])?.count ?? 0 != recipe.subRecipesArr.count {
                    changedArr.append(record)
                }
            } else {
                newArr.append(record)
            }
            
        }
        print("\(newArr.count) of \(records.count) Recipes new!")
        print("\(changedArr.count) of \(records.count) Recipes changed!")
        return (newArr, changedArr)
    }
    
    static func setUpSubscriptions() { // Sets up Subscriptions

    }
    
    static func handleRecipeChangedNotification() { // Called when Recipe changed in public DB
        fetchDefaultZoneChanges()
    }
    
    @objc static func fetchDefaultZoneChanges(completion: @escaping() -> Void = {() in}) { // Look for and apply changes to Recipes
        downloadAllRecipesFromCloud { (records) in
            let (newRecords, changedRecords) = checkForChanges(records: records)
            createRecipeObjects(records: newRecords)
            overwriteRecipeObjects(records: changedRecords)
            completion()
        }
    }
    
    // PREFERRED
    static func fetchReferences(withKey key: String, andRecordType recordType: String, forSourceRecordID sourceID: CKRecord.ID, completionHandler: @escaping(([CKRecord]) -> Void)) {
        
        let predicate = NSPredicate(format: "\(key) = %@", sourceID)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: .default) { (records, error) in
            guard error == nil, let records = records else { print(error?.localizedDescription ?? ""); return }
            
            completionHandler(records)
        }
    }
    
    static func fetchReference(reference: CKRecord.Reference?, completionHandler: @escaping((CKRecord) -> Void)) {
        guard let reference = reference else { return }
        publicDB.fetch(withRecordID: reference.recordID) { (record, error) in
            if error != nil {
                print(error!)
            } else {
                completionHandler(record!)
            }
        }
    }
    
    // UPLOAD
    static func uploadRecipe(recipe: Recipe, completionHanlder: @escaping(Bool, CKRecord?) -> Void) {
        let group = DispatchGroup()
        
        let recipeRecord = CKRecord(recordType: "Recipe")
        let recipeReference = CKRecord.Reference(record: recipeRecord, action: .deleteSelf)
        
        // SubRecipes
        var subRecipeReferences = [CKRecord.Reference]()
        for subRecipe in recipe.subRecipesArr {
            let subRecipeRecord = CKRecord(recordType: "SubRecipe")
            let subRecipeReference = CKRecord.Reference(record: subRecipeRecord, action: .deleteSelf)
            subRecipeReferences.append(subRecipeReference)
            
            // Ingredients
            var ingredientReferences = [CKRecord.Reference]()
            for ingredient in subRecipe.ingredients {
                let ingredientRecord = CKRecord(recordType: "Ingredients")
                let ingredientReference = CKRecord.Reference(record: ingredientRecord, action: .deleteSelf)
                ingredientReferences.append(ingredientReference)
                
                let unitName: String = {() -> String in
                    switch ingredient.type.unit {
                    case .amount(let unit):
                        switch unit {
                        case .custom(let unitName): return unitName
                        default: return "" }
                    default: return "" }
                }()
                
                ingredientRecord.setValuesForKeys([
                    "subRecipe" : subRecipeReference,
                    "name" : ingredient.type.name,
                    "amount" : ingredient.amount,
                    "unitKey" : ingredient.type.unit.key,
                    "unitName" : unitName
                ])
                
                group.enter()
                publicDB.save(ingredientRecord) { (record, error) in
                    if error != nil { print(error!); completionHanlder(false, nil); return }
                    print("Ingredient saved:  \(ingredient.type.name)")
                    group.leave()
                }
            }
            
            
            subRecipeRecord.setValuesForKeys([
                "recipe" : recipeReference,
                "name" : subRecipe.name,
                "index" : Int64(subRecipe.index),
                "ingredients" : ingredientReferences
            ])
            
            group.enter()
            publicDB.save(subRecipeRecord) { (record, error) in
                if error != nil { print(error!); completionHanlder(false, nil); return }
                print("SubRecipe saved:  \(subRecipe.name)")
                group.leave()
            }
        }
        
        var recipeAssets = [CKAsset]()
        for image in recipe.imageArray where image != nil {
            do { recipeAssets.append(try CKAsset(image: image!))
            } catch { print(error.localizedDescription) }
        }
        
        recipeRecord.setValuesForKeys([
            "name" : recipe.name,
            "categoriesString" : recipe.categoriesString,
            "tagsString" : recipe.tagsString,
            "preperationSteps" : recipe.preperationStepsArr.map({$0.text}),
            "infoString" : recipe.infoString,
            "images" : recipeAssets,
            "subRecipes" : subRecipeReferences
        ])
        
        group.enter()
        publicDB.save(recipeRecord) { (record, error) in
            if error != nil { print(error!); completionHanlder(false, nil); return }
            recipe.recordName = record?.recordID.recordName ?? ""
            recipe.modificationDate = record?.modificationDate
            recipe.creationDate = record?.creationDate
            print("Recipe saved:  \(recipe.name)")
            group.leave()
        }
        
        group.notify(queue: .main) {
            PersistenceService.saveContext()
            completionHanlder(true, recipeRecord)
        }
    }
    
    static func updateRecipeToCloud(recipe: Recipe, completionHanlder: @escaping(Bool, CKRecord?) -> Void) {
        
        let group = DispatchGroup()
        
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: recipe.recordName)) { (record, error) in
            if let error = error { print(error.localizedDescription) }
            if let recipeRecord = record {
                
                let recipeReference = CKRecord.Reference(record: recipeRecord, action: .deleteSelf)
                
                // SubRecipes
                var subRecipeReferences = [CKRecord.Reference]()
                for subRecipe in recipe.subRecipesArr {
                    let subRecipeRecord = CKRecord(recordType: "SubRecipe")
                    let subRecipeReference = CKRecord.Reference(record: subRecipeRecord, action: .deleteSelf)
                    subRecipeReferences.append(subRecipeReference)
                    
                    // Ingredients
                    var ingredientReferences = [CKRecord.Reference]()
                    for ingredient in subRecipe.ingredients {
                        let ingredientRecord = CKRecord(recordType: "Ingredients")
                        let ingredientReference = CKRecord.Reference(record: ingredientRecord, action: .deleteSelf)
                        ingredientReferences.append(ingredientReference)
                        
                        let unitName: String = {() -> String in
                            switch ingredient.type.unit {
                            case .amount(let unit):
                                switch unit {
                                case .custom(let unitName): return unitName
                                default: return "" }
                            default: return "" }
                        }()
                        
                        ingredientRecord.setValuesForKeys([
                            "subRecipe" : subRecipeReference,
                            "name" : ingredient.type.name,
                            "amount" : ingredient.amount,
                            "unitKey" : ingredient.type.unit.key,
                            "unitName" : unitName
                        ])
                        
                        group.enter()
                        publicDB.save(ingredientRecord) { (record, error) in
                            if error != nil { print(error!); completionHanlder(false, nil); return }
                            print("Ingredient saved:  \(ingredient.type.name)")
                            group.leave()
                        }
                    }
                    
                    
                    subRecipeRecord.setValuesForKeys([
                        "recipe" : recipeReference,
                        "name" : subRecipe.name,
                        "index" : Int64(subRecipe.index),
                        "ingredients" : ingredientReferences
                    ])
                    
                    group.enter()
                    publicDB.save(subRecipeRecord) { (record, error) in
                        if error != nil { print(error!); completionHanlder(false, nil); return }
                        print("SubRecipe saved:  \(subRecipe.name)")
                        group.leave()
                    }
                }
                
                var recipeAssets = [CKAsset]()
                for image in recipe.imageArray where image != nil {
                    do { recipeAssets.append(try CKAsset(image: image!))
                    } catch { print(error) }
                }
                
                recipeRecord.setValuesForKeys([
                    "name" : recipe.name,
                    "categoriesString" : recipe.categoriesString,
                    "tagsString" : recipe.tagsString,
                    "preperationSteps" : recipe.preperationStepsArr.map({$0.text}),
                    "infoString" : recipe.infoString,
                    "images" : recipeAssets,
                    "subRecipes" : subRecipeReferences
                ])
                
                group.notify(queue: .main) {
                    let operation = CKModifyRecordsOperation(recordsToSave: [recipeRecord], recordIDsToDelete: nil)
                    operation.modifyRecordsCompletionBlock = { modifiedRecords, _, error in
                        if let error = error { print(error) }
                        if modifiedRecords?.count ?? 0 > 0, let modifiedRecord = modifiedRecords?[0] {
                            completionHanlder(true, modifiedRecord)
                            recipe.modificationDate = modifiedRecord.modificationDate
                            PersistenceService.saveContext()
                        } else {
                            completionHanlder(false, nil)
                        }
                    }
                    
                    publicDB.add(operation)
                }
            }
        }
    }
    
    static func deleteRecipeFromCloud(recipe: Recipe, completionHanlder: @escaping(Bool, CKRecord.ID?) -> Void) {
        guard recipe.recordName != "" else { completionHanlder(false, nil); return }
        let recipeRecordID = CKRecord.ID(recordName: recipe.recordName)
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [recipeRecordID])
        operation.modifyRecordsCompletionBlock = { _, deletedRecordIDs, error in
            if let error = error { print(error.localizedDescription) }
            if let deletedRecordID = deletedRecordIDs?[0] {
                completionHanlder(true, deletedRecordID)
            } else {
                completionHanlder(false, nil)
            }
        }
        publicDB.add(operation)
    }
}
