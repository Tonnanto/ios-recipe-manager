//
//  AppDelegate.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        CloudKitService.setUpSubscriptions()
        UIApplication.shared.registerForRemoteNotifications()
        
        let fetchIngredientTypesRequest: NSFetchRequest<IngredientType> = IngredientType.fetchRequest()
        let fetchRecipeBooksRequest: NSFetchRequest<RecipeBook> = RecipeBook.fetchRequest()

        let fetchRecipesRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        do {
            let fetchedIngredientTypes = try PersistenceService.context.fetch(fetchIngredientTypesRequest)
            let fetchedRecipes = try PersistenceService.context.fetch(fetchRecipesRequest)
            let fetchedRecipeBooks = try PersistenceService.context.fetch(fetchRecipeBooksRequest)

            
            if fetchedIngredientTypes.count == 0 {
                IngredientType.initializeIngredientTypes()
                print("IngredientTypes initialized")
            } else {
                ingredientTypes = fetchedIngredientTypes.sorted(by: {$0.name < $1.name})
                print("IngredientTypes fetched")
            }
            
            
            if fetchedRecipes.count == 0 {
//                Recipe.initializeRecipes()
//                print("Recipes initialized")
            } else {
                recipes = fetchedRecipes
                print("Recipes fetched")
            }
            
            if fetchedRecipeBooks.count == 0 {
                print("No RecipeBooks Added yet")
            } else {
                recipeBooks = fetchedRecipeBooks
                print("RecipeBooks fetched")
            }
            
            PersistenceService.saveContext()
        }
        catch {
            print("There was a fetch error")
        }
        
        
        CloudKitService.fetchDefaultZoneChanges() {

        }
        
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("recieved Remote Notification")
        
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo as! [String: NSObject])!
        
        if notification.subscriptionID == CloudKitService.publicRecipesSubscriptionID {
            CloudKitService.handleRecipeChangedNotification()
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Did register remote Notification")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Did fail to register remote notification")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

