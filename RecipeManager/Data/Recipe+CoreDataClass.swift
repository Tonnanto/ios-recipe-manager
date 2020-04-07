//
//  Recipe+CoreDataClass.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit
import UIKit

@objc(Recipe)
public class Recipe: NSManagedObject {
    
    static var recipesUpdatedNotification = Notification.Name("recipesUpdated")
    var record: CKRecord?
    
    var categoiesArr: [Category] {
        get {
            var arr: [Category] = []
            for key in categoriesString.components(separatedBy: ",") {
                if let cat = Category.categoryForKey(key) { arr.append(cat) }
            }
            return arr
        }
        set {
            var str = ""
            for (i, cat) in newValue.enumerated() {
                str.append(cat.key)
                if i != newValue.count - 1 { str.append(",") }
            }
            self.categoriesString = str
        }
    }
    
    var imageArray: [UIImage?] {
        get {
            do {
                if let images = images, let imagesNSArray = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: images) {

                    if let imgArray = imagesNSArray as? [Data] {
                        var arr: [UIImage?] = []
                        for data in imgArray {
                            arr.append(UIImage(data: data))
                        }
                        return arr
                    }
                }
            } catch { print(error.localizedDescription) }
            return []
        }
        set {
            let dataArray = NSMutableArray()

            for img in newValue where img != nil {
                if let imgData = UIImage.pngData(img!)() {
                    let data = NSData(data: imgData)
                    dataArray.add(data)
                }
            }
            
            do {
                let coreDataObject = try NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: false)
                self.images = coreDataObject
            } catch { print(error.localizedDescription) }
        }
    }
    
    var infoArray: [InfoType] {
        get {
            return self.infoStringToArray()
        }
        set {
            var string = ""
            for (index, info) in newValue.enumerated() where info.key != "dateAdded" || info.key != "totalTime" {
                if index != 0 { string.append(";")}
                string.append(info.toString())
            }
            self.infoString = string
        }
    }
    
    var defaultDishAmount: Int? {
        if let dishAmount = infoArray.first(where: {$0.key == "serves"}) {
            switch dishAmount {
            case .serves(let i): return Int(i)
            default: return nil
            }
        } else {
            return nil
        }
    }
        
    var subRecipesArr: [SubRecipe] {
        return (subRecipes.array as? [SubRecipe])?.sorted(by: {$0.index < $1.index}) ?? []
    }
    
    var preperationStepsArr: [PreperationStep] {
        return preperationSteps.array as? [PreperationStep] ?? []
    }
    
    var tagsArr: [String] {
        get {
            return tagsString.components(separatedBy: ",")
        }
        set {
            var str = ""
            for (i, tag) in newValue.enumerated() {
                str.append(tag)
                if i != newValue.count - 1 { str.append(",") }
            }
            self.tagsString = str
        }
    }
    
    init(name: String, images: [UIImage?], ingredients: [Ingredient], preperationSteps: [PreperationStep], subRecipes: [SubRecipe] = [], infoTypes: [InfoType], categories: [Category], tags: [String] = []) {
        super.init(entity: Recipe.entity(), insertInto: PersistenceService.context)
        self.imageArray = images
        self.name = name
        self.infoArray = infoTypes
        self.categoiesArr = categories
        self.tagsArr = tags
        for step in preperationSteps { self.addToPreperationSteps(step) }

        self.addToSubRecipes(SubRecipe(name: "main", index: 0, ingredients: ingredients))
        
        for subRecipe in subRecipes {
            self.addToSubRecipes(subRecipe)
        }
    }
    
    init?(record: CKRecord, subRecipes: [SubRecipe], completionHandler: @escaping(Recipe) -> Void) throws {
        super.init(entity: Recipe.entity(), insertInto: PersistenceService.context)
        self.record = record
        
        guard let name = record.value(forKey: "name") as? String else {
            throw RecipeSaveError.dataMissing(missing: "name") }
        guard let preperationSteps = record.value(forKey: "preperationSteps") as? [String] else {
            throw RecipeSaveError.dataMissing(missing: "preperationSteps") }
        guard let _ = record.value(forKey: "subRecipes") as? [CKRecord.Reference] else {
            throw RecipeSaveError.dataMissing(missing: "Recipe.subRecipes") }
        
        var images: [UIImage] = []
        if let assets = record.value(forKey: "images") as? [CKAsset] {
            for asset in assets { if let image = asset.toUIImage() { images.append(image) } }
        }
        
        let infoString = record.value(forKey: "infoString") as? String
        let categoriesString = record.value(forKey: "categoriesString") as? String
        let tagsString = record.value(forKey: "tagsString") as? String
        let modificationDate = record.modificationDate
        let creationDate = record.creationDate
        
        self.recordName = record.recordID.recordName
        self.name = name
        self.categoriesString = categoriesString ?? ""
        self.tagsString = tagsString ?? ""
        self.imageArray = images
        self.infoString = infoString ?? ""
        self.modificationDate = modificationDate
        self.creationDate = creationDate
        
        for prepStepText in preperationSteps {
            let prepStep = PreperationStep(text: prepStepText)
            prepStep.recipe = self
            self.addToPreperationSteps(prepStep)
        }
                
        for subRecipe in subRecipes {
            subRecipe.recipe = self
            self.addToSubRecipes(subRecipe)
        }
        
        completionHandler(self)
    }
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    func syncToRecord(_ record: CKRecord, completionHandler: @escaping(Bool, Int) -> Void) {
        self.record = record
        guard let name = record.value(forKey: "name") as? String else {
            print("Failed to Overwrite Recipe Obj: name missing")
            completionHandler(false, 0)
            return
        }
        guard let preperationSteps = record.value(forKey: "preperationSteps") as? [String] else {
            print("Failed to Overwrite Recipe Obj: preperationSteps missing")
            completionHandler(false, 0)
            return
        }
        
        var images: [UIImage] = []
        if let assets = record.value(forKey: "images") as? [CKAsset] {
            for asset in assets { if let image = asset.toUIImage() { images.append(image) } }
        }
        
        var countChanges = 0
        
        let categoriesString = record.value(forKey: "categoriesString") as? String
        let tagsString = record.value(forKey: "tagsString") as? String
        let modificationDate = record.modificationDate
        
        if (self.name != name) { self.name = name; countChanges += 1 }
        if (self.categoriesString != categoriesString) { self.categoriesString = categoriesString ?? ""; countChanges += 1 }
        if (self.tagsString != tagsString) { self.tagsString = tagsString ?? ""; countChanges += 1 }
        
        // Preperation Steps
        if self.preperationStepsArr.count != preperationSteps.count {
            self.removeFromPreperationSteps(self.preperationSteps)
            for prepStep in preperationSteps{ self.addToPreperationSteps(PreperationStep(text: prepStep)); countChanges += 1 }
        }
        for (index, preperationStep) in preperationSteps.enumerated() {
            if self.preperationStepsArr[index].text != preperationStep {
                self.preperationStepsArr[index].text = preperationStep
                countChanges += 1
            }
        }
        
        // SubRecipes
        
        self.fetchSubRecipes { (subRecipes) in
            guard let subRecipes = subRecipes else { completionHandler(false, countChanges); return }
            self.removeFromSubRecipes(self.subRecipes)
            subRecipes.forEach({ subRecipe in self.addToSubRecipes(subRecipe) })
            print("Successfully overwritten new Recipe Obj: \(record.recordID.recordName)")
            
            self.modificationDate = modificationDate
            
            completionHandler(true, countChanges)
        }
    }
    
    func fetchSubRecipes(completionHandler: @escaping([SubRecipe]?) -> Void) {
        
        guard let subRecipeReferences = self.record?.value(forKey: "subRecipes") as? [CKRecord.Reference] else {
            print("Fetching SubRecipes failed: No Record or SubRecipeReferences")
            completionHandler(nil)
            return
        }
        
        let group = DispatchGroup()
        var subRecipes: [SubRecipe] = []
        
        for subRecipeReference in subRecipeReferences {
            group.enter()
            CloudKitService.fetchReference(reference: subRecipeReference) { (subRecipeRecord) in
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
            print("Successfully fetched SubRecipes for Recipe Obj: \(self.name)")
            completionHandler(subRecipes)
        }
    }
    
    func favourite() {
        if imageArray.count > 0 {
            TabBarController.main?.animateThumbnailWishlist(image: imageArray[0])
        }
        if !favouriteRecipes.contains(where: {$0 === self}) {
            self.isFavourite = true
        }
    }
    
    func unfavourite() {
        self.isFavourite = false
    }
    

    
    enum RecipeSaveError: Error {
        case dataMissing(missing: String)
        case dataIncorrect(String)
    }
}
