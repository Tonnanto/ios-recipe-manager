//
//  RecipeBook+CoreDataClass.swift
//  RecipeManager
//
//  Created by Anton Stamme on 09.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


@objc(RecipeBook)
public class RecipeBook: NSManagedObject {
    
    static var recipeBooksUpdatedKey = Notification.Name("RecipeBook.recipeBooksUpdated")

    var color: Color {
        return Color.colorForKey(appearenceString)
    }
    
    var icon: UIImage? {
        get {
            guard let data = imageData else { return nil }
            return UIImage(data: data)
        }
        set {
            if let img = newValue, let imgData = UIImage.pngData(img)() {
                imageData = imgData
            }
        }
    }
    
    var recipesArr: [Recipe] {
        return (recipes.array as? [Recipe])?.sorted(by: {$0.creationDate ?? Date(timeIntervalSince1970: 0) > $1.creationDate ?? Date(timeIntervalSince1970: 0)}) ?? []
    }
}
