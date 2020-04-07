//
//  RecipeDetailViewController.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailViewController: UIViewController {
    
    var recipe: Recipe?
    
    static var contentInset: CGFloat = 12
    static var recipeUpdatedKey = Notification.Name("RecipeDetailViewController.recipeUpdatedKey")
    
    var content: [ContentType] = [.images, .title, .categories, .info, .servesCounter, .ingredients, .preperation]
        
    var currentDishAmount: Int = 1 {
        didSet {
            collectionView.reloadData()
            ingredientsView.tableView.reloadData()
        }
    }
    
    lazy var ingredientsView: OverlayView = {
        let view = OverlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view._target = self
        return view
    }()
    
    enum ContentType {
        case images
        case categories
        case title
        case info
        case servesCounter
        case ingredients
        case preperation
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        fillData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let recipe = recipe, recipes.contains(recipe) else {
            navigationController?.popViewController(animated: true)
            return
        }
        collectionView.reloadData()
        NotificationCenter.default.post(name: RecipeDetailViewController.recipeUpdatedKey, object: nil)
    }
    
    func setUpViews() {
        collectionView.register(RecipeDetailImagesCell.self, forCellWithReuseIdentifier: "RecipeDetailImagesCell")
        collectionView.register(RecipeDetailCategoriesCell.self, forCellWithReuseIdentifier: "RecipeDetailCategoriesCell")
        collectionView.register(RecipeDetailTitleCell.self, forCellWithReuseIdentifier: "RecipeDetailTitleCell")
        collectionView.register(RecipeDetailInfoCell.self, forCellWithReuseIdentifier: "RecipeDetailInfoCell")
        collectionView.register(RecipeDetailServesCounterCell.self, forCellWithReuseIdentifier: "RecipeDetailServesCounterCell")
        collectionView.register(RecipeDetailIngredientsCell.self, forCellWithReuseIdentifier: "RecipeDetailIngredientsCell")
        collectionView.register(RecipeDetailPreperationCell.self, forCellWithReuseIdentifier: "RecipeDetailPreperationCell")
                
        view.addSubview(ingredientsView)
        ingredientsView.setUpViews()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: OverlayView.headerHeight, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: OverlayView.headerHeight, right: 0)

    }
    
    func fillData() {
        if let recipe = recipe {
            
            if let dishAmount = recipe.defaultDishAmount {
                currentDishAmount = dishAmount
            } else {
                content.removeAll(where: {$0 == .servesCounter})
                currentDishAmount = 1
            }
            
            if recipe.imageArray.count == 0 {
                content.removeAll(where: {$0 == .images})
                collectionView.contentInset.top = RecipeDetailViewController.contentInset
            }
        }
        view.layoutSubviews()
        collectionView.reloadData()
    }
    
    static func seperator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        view.backgroundColor = UIColor(named: "tint")
        return view
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditRecipeViewController", let vc = (segue.destination as? UINavigationController)?.viewControllers[0] as? NewRecipeViewController {
            
            vc.editingRecipe = recipe
        }
    }
}

extension RecipeDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = content[indexPath.item]
        switch c {
        case .images:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeDetailImagesCell", for: indexPath) as! RecipeDetailImagesCell
            cell._target = self
            cell.fillData()
            return cell
        case .categories:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeDetailCategoriesCell", for: indexPath) as! RecipeDetailCategoriesCell
            cell._target = self
            cell.fillData()
            return cell
        case .title:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeDetailTitleCell", for: indexPath) as! RecipeDetailTitleCell
            cell._target = self
            cell.fillData()
            return cell
        case .info:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeDetailInfoCell", for: indexPath) as! RecipeDetailInfoCell
            cell._target = self
            cell.fillData()
            return cell
        case .servesCounter:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeDetailServesCounterCell", for: indexPath) as! RecipeDetailServesCounterCell
            cell._target = self
            cell.fillData()
            return cell
        case .ingredients:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeDetailIngredientsCell", for: indexPath) as! RecipeDetailIngredientsCell
            cell._target = self
            cell.fillData()
            return cell
        case .preperation:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeDetailPreperationCell", for: indexPath) as! RecipeDetailPreperationCell
            cell._target = self
            cell.fillData()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let c = content[indexPath.item]
        let width = collectionView.bounds.width
        switch c {
        case .images: return CGSize(width: width, height: width)
        case .categories: return CGSize(width: width, height: 84)
        case .title:
            let titleHeight = recipe?.name.heightWithConstrainedWidth(width: width - (2 * RecipeDetailViewController.contentInset) - 50, font: RecipeDetailTitleCell.titleFont) ?? 80
            return CGSize(width: width, height: titleHeight)
        case .info: return CGSize(width: width, height: RecipeDetailInfoCell.heightForNumberOfItems(recipe?.infoArray.count ?? 0))
        case .servesCounter: return CGSize(width: width, height: 60)
        case .ingredients: return CGSize(width: width, height: RecipeDetailIngredientsCell.heightForRecipe(recipe))
        case .preperation: return CGSize(width: width, height: RecipeDetailPreperationCell.heightForRecipe(recipe, cvWidth: collectionView.bounds.width))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.indexPathForItem(at: CGPoint(x: collectionView.center.x, y: collectionView.contentOffset.y + collectionView.center.x))?.item ?? 0 >= content.firstIndex(of: .preperation) ?? 5 {
            if ingredientsView.topAnchorContraint?.constant ?? 0 >= ingredientsView.bottomPositionConstant {
                ingredientsView.hide(false)
                
            }
            
        } else {
            ingredientsView.hide(true)

        }
    }
}
