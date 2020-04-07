//
//  NewRecipeViewController.swift
//  RecipeManager
//
//  Created by Anton Stamme on 21.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class NewRecipeViewController: UIViewController {
    
    var editingRecipe: Recipe? // nil if new Recipe
   
    var recipeImages: [UIImage] = []
    var recipeCategories: [Recipe.Category] = []
    var recipeTitle: String?
    var recipeInfoTypes: [Recipe.InfoType] = []
    
    var recipeIngredients: [(name: String, ingredients: [Ingredient])] = [("main", [NewRecipeIngredientsCell.newIngredient()])]
    var recipePreperationSteps: [PreperationStep] = [PreperationStep(context: PersistenceService.context)]
    var recipeTags: [String] = []
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Next", comment: ""), style: .plain, target: self, action: #selector(handleNextButton(_:)))
        return button
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(handleBackButton))
        return button
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(handleCancelButton))
        return button
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(handleSaveButton))
        return button
    }()
    
    lazy var processIndicator: NewRecipeProgressIndicator = {
        let view = NewRecipeProgressIndicator()
        view.translatesAutoresizingMaskIntoConstraints = false
        view._target = self
        return view
    }()
    
    lazy var flexSpace: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }()
    
    lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditButton))
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButton))
    }()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var currentPage: Int = 0 {
        didSet {
            view.endEditing(true)
            if currentPage == 0 {
                navigationItem.setLeftBarButtonItems([cancelButton], animated: true)
            } else {
                navigationItem.setLeftBarButtonItems([backButton], animated: true)
            }
            
            if currentPage == content.count - 1 {
                navigationItem.setRightBarButtonItems([saveButton], animated: true)
            } else {
                navigationItem.setRightBarButtonItems([nextButton], animated: true)
            }
            
            switch content[currentPage] {
            case .detail:
                toolBar.setItems([flexSpace], animated: true)
            case .ingredients, .preperationSteps:
                toolBar.setItems([flexSpace, editButton], animated: true)
            }
        }
    }
    
    var content: [ContentType] = [.detail, .ingredients, .preperationSteps]
    enum ContentType {
        case detail
        case ingredients
        case preperationSteps
    }
    
    override func viewDidLoad() {
        setUpViews()
        fillData()
    }
    
    func setUpViews() {
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.backgroundColor = .systemBackground
        navigationBarAppearence.shadowColor = .clear
        navigationController!.navigationBar.standardAppearance = navigationBarAppearence
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(NewRecipeDetailCell.self, forCellWithReuseIdentifier: "NewRecipeDetailCell")
        collectionView.register(NewRecipeIngredientsCell.self, forCellWithReuseIdentifier: "NewRecipeIngredientsCell")
        collectionView.register(NewRecipePreperationStepsCell.self, forCellWithReuseIdentifier: "NewRecipePreperationStepsCell")

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let height: CGFloat = 36
        
        headerView.addSubview(processIndicator)
        headerView.addConstraints([
            NSLayoutConstraint(item: processIndicator, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: processIndicator, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: processIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height),
            NSLayoutConstraint(item: processIndicator, attribute: .width, relatedBy: .equal, toItem: headerView, attribute: .width, multiplier: 0.6, constant: 0)
        ])
        
        processIndicator.setUpViews(height: height)
    }
    
    func fillData() {
        if let recipe = editingRecipe {
            self.navigationItem.title = NSLocalizedString("Editing Recipe", comment: "")
            
            recipeTitle = recipe.name
            recipeImages = recipe.imageArray.filter({$0 != nil}) as! [UIImage]
            recipeCategories = recipe.categoiesArr
            recipeInfoTypes = recipe.infoArray
            recipePreperationSteps = recipe.preperationStepsArr
            recipeTags = recipe.tagsArr
            
            recipeIngredients.removeAll()
            for subRecipe in recipe.subRecipesArr {
                recipeIngredients.append((subRecipe.name, subRecipe.ingredients))
            }
        }
        
//        collectionView.reloadData()
    }
    
    @objc func handleEditButton() {
        switch content[currentPage] {
        case .ingredients:
            if let page = collectionView.cellForItem(at: IndexPath(item: currentPage, section: 0)) as? NewRecipeIngredientsCell {
                page.tableView.setEditing(true, animated: true)
            }
        case .preperationSteps:
            if let page = collectionView.cellForItem(at: IndexPath(item: currentPage, section: 0)) as? NewRecipePreperationStepsCell {
                page.tableView.setEditing(true, animated: true)
            }
        default: break
        }
        toolBar.setItems([flexSpace, doneButton], animated: true)
    }
    
    @objc func handleDoneButton() {
        switch content[currentPage] {
        case .ingredients:
            if let page = collectionView.cellForItem(at: IndexPath(item: currentPage, section: 0)) as? NewRecipeIngredientsCell {
                page.tableView.setEditing(false, animated: true)
            }
        case .preperationSteps:
            if let page = collectionView.cellForItem(at: IndexPath(item: currentPage, section: 0)) as? NewRecipePreperationStepsCell {
                page.tableView.setEditing(false, animated: true)
            }
        default: break
        }
        toolBar.setItems([flexSpace, editButton], animated: true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()

//        if let currentIndex = collectionView.indexPathForItem(at: CGPoint(x: collectionView.center.x + collectionView.contentOffset.x, y: collectionView.center.y)) {
//            collectionView.scrollToItem(at: currentIndex, at: .centeredHorizontally, animated: false)
//        }
    }
    
    @objc func handleCancelButton(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
   @objc func handleNextButton(_ sender: Any) {
        guard currentPage < content.count else { return }
        collectionView.scrollToItem(at: IndexPath(item: currentPage + 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func handleBackButton(_ sender: Any) {
        guard currentPage > 0 else { return }
        collectionView.scrollToItem(at: IndexPath(item: currentPage - 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    var titleMissing = false
    @objc func handleSaveButton(_ sender: Any) {
        let completionError = recipeComplete()
        if let error = completionError { // Recipe incomplete
            var title = ""
            var message = ""
            switch error {
            case .titleMissing: title = NSLocalizedString("Title missing", comment: ""); message = NSLocalizedString("Please add a Title to your recipe.", comment: "")
            case .ingredientMising: title = NSLocalizedString("Ingredients missing", comment: ""); message = NSLocalizedString("Please add at least one ingredient to your recipe.", comment: "")
            case .preperationStepMissing: title = NSLocalizedString("Preperation Steps missing", comment: ""); message = NSLocalizedString("Please add at least one preperation step to your recipe.", comment: "")
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                switch error {
                case .titleMissing:
                    let ip = IndexPath(item: 0, section: 0)
                    self.titleMissing = true
                    self.collectionView.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
                    
                case .ingredientMising:
                    let ip = IndexPath(item: 1, section: 0)
                    self.collectionView.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)

                case .preperationStepMissing:
                    let ip = IndexPath(item: 2, section: 0)
                    self.collectionView.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)

                }
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else { // Recipe complete
            
            let filteredPreperationSteps = recipePreperationSteps.filter({$0.text != ""})
            let filteredInfoTypes = recipeInfoTypes.filter({
                switch $0 {
                case .cookTime(let i), .prepTime(let i), .serves(let i):
                    return i != 0 ? true : false
                case .ovenTemp(let i, unit: _):
                    return i != 0 ? true : false
                default:
                    return true
                }
            })
            
            if let editingRecipe = editingRecipe {  // Edit existing Recipe
                editingRecipe.name = recipeTitle!
                editingRecipe.imageArray = recipeImages
                editingRecipe.infoArray = filteredInfoTypes
                editingRecipe.categoiesArr = recipeCategories
                editingRecipe.tagsArr = recipeTags
                
                editingRecipe.removeFromSubRecipes(editingRecipe.subRecipes)
                for (index, ingredientList) in recipeIngredients.enumerated() {//} where ingredientList.name != "main" {
                    let subRecipe = SubRecipe(context: PersistenceService.context)
                    subRecipe.name = ingredientList.name
                    subRecipe.index = Int16(index)
                    ingredientList.ingredients.forEach({ingredient in subRecipe.addToIngredientList(ingredient)})
                    editingRecipe.addToSubRecipes(subRecipe)
                }
                
                editingRecipe.removeFromPreperationSteps(editingRecipe.preperationSteps)
                for prepStep in filteredPreperationSteps {
                    editingRecipe.addToPreperationSteps(prepStep)
                }
                CloudKitService.updateRecipeToCloud(recipe: editingRecipe) { (success, record) in
                    if success { print("Successfully updated Recipe: \(editingRecipe.name)") }
                }
                
            } else {  // Create new Recipe
//                let mainRecipe = SubRecipe(context: PersistenceService.context)
//                mainRecipe.name = recipeIngredients[0].name
//                mainRecipe.index = 0
//                recipeIngredients[0].ingredients.forEach({ingredient in mainRecipe.addToIngredientList(ingredient)})

                var subRecipes: [SubRecipe] = []
                for (index, ingredientList) in recipeIngredients.enumerated() {//} where ingredientList.name != "main" {
                    let subRecipe = SubRecipe(context: PersistenceService.context)
                    subRecipe.name = ingredientList.name
                    subRecipe.index = Int16(index)
                    ingredientList.ingredients.forEach({ingredient in subRecipe.addToIngredientList(ingredient)})
                    subRecipes.append(subRecipe)
                }
                
                let recipe = Recipe(context: PersistenceService.context)
                recipe.name = recipeTitle!
                recipe.imageArray = recipeImages
                recipe.infoArray = filteredInfoTypes
                recipe.categoiesArr = recipeCategories
                recipe.tagsArr = recipeTags
                for step in filteredPreperationSteps { recipe.addToPreperationSteps(step) }
                
//                recipe.addToSubRecipes(SubRecipe(name: "main", index: 0, ingredients: mainIngredients))
                for subRecipe in subRecipes {
                    recipe.addToSubRecipes(subRecipe)
                }
                
                recipes.append(recipe)
                CloudKitService.uploadRecipe(recipe: recipe) { (success, record) in

                }
            }

            PersistenceService.saveContext()
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func recipeComplete() -> RecipeIncompleteError? {
        guard recipeTitle != "" && recipeTitle != nil else { return .titleMissing }
        guard recipeIngredients[0].ingredients.filter({$0.type.name != ""}).count > 0 else { return .ingredientMising }
        guard recipePreperationSteps.filter({$0.text != ""}).count > 0 else { return .preperationStepMissing }
        return nil
    }
    
    enum RecipeIncompleteError: Error {
        case titleMissing
        case ingredientMising
        case preperationStepMissing
    }
}


extension NewRecipeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = content[indexPath.item]
        switch c {
        case .detail:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRecipeDetailCell", for: indexPath) as! NewRecipeDetailCell
            cell._target = self
            cell.fillData()
            return cell
            
        case .ingredients:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRecipeIngredientsCell", for: indexPath) as! NewRecipeIngredientsCell
            cell._target = self
            cell.fillData()
            return cell
            
        case .preperationSteps:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRecipePreperationStepsCell", for: indexPath) as! NewRecipePreperationStepsCell
            cell._target = self
            cell.fillData()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)// - collectionView.safeAreaInsets.bottom)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        processIndicator.contentOffsetChanged(offset)
        
        let firstPagePos: CGFloat = 0
        let secondPagePos: CGFloat = collectionView.bounds.width
        let thirdPagePos: CGFloat = collectionView.bounds.width * 2
        
        if offset < (firstPagePos + secondPagePos) / 2 {
            if currentPage != 0 { currentPage = 0; generator.impactOccurred() }
        } else if offset < (secondPagePos + thirdPagePos) / 2 {
            if currentPage != 1 { currentPage = 1; generator.impactOccurred() }
        } else {
            if currentPage != 2 { currentPage = 2; generator.impactOccurred() }
        }
    }
        
    // Select Title TextView if Title was missing
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 && titleMissing {
            if let detailPage = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? NewRecipeDetailCell {
                if let titleCell = detailPage.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? NewRecipeDetailTitleCell {
                    titleCell.textView.becomeFirstResponder()
                    titleMissing = false
                }
            }
        }
    }
}
