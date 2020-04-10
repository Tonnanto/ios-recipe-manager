//
//  RecipesViewController.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipesViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    
    var recipeBook: RecipeBook?
    var recipeArr: [Recipe] {
        guard let recipeBook = recipeBook else { return sortedRecipes }
        return recipeBook.recipesArr
    }
    
    var loading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                
                if !self.loading {
                    self.tableView.beginUpdates()
                    self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
                    self.tableView.endUpdates()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.tintColor = UIColor(named: "heavyTint")
        controller.obscuresBackgroundDuringPresentation = false
        controller.delegate = self
        controller.searchBar.delegate = self
        return controller
    }()
    
    var selectedCategories: [Recipe.Category] = [] {
        didSet {
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            tableView.endUpdates()
        }
    }
    
    var filteredRecipes: [Recipe] = []
    var currentRecipes: [Recipe] {
        let _recipeArr = searchController.searchBar.text != "" ? filteredRecipes : recipeArr
        return _recipeArr.filter({recipe in
            if selectedCategories.count != 0 {
                for selectedCat in selectedCategories {
                    if !recipe.categoiesArr.contains(selectedCat) {
                        return false
                    }
                }
            }
            return true
        })
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moreButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        fillData()
    }
    
    func setUpViews() {
        self.navigationItem.searchController = searchController
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadRecipes), for: .valueChanged)

        NotificationCenter.default.addObserver(self, selector: #selector(fillData), name: Recipe.recipesUpdatedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fillData), name: RecipeBook.recipeBooksUpdatedKey, object: nil)
    }

    @objc func fillData() {
        if let recipeBook = recipeBook, !recipeBooks.contains(recipeBook) {
            navigationController?.popViewController(animated: true)
            return
        }
        navigationItem.title = recipeBook?.name ?? NSLocalizedString("Recipes", comment: "")
        tableView.reloadData()
    }
    
    @objc func reloadRecipes() {
        self.refreshControl.endRefreshing()
        loading = true
        CloudKitService.fetchDefaultZoneChanges {
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    @IBAction func handleMoreButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let newRecipeAction = UIAlertAction(title: "Add New Recipe", style: .default) { (action) in
            self.performSegue(withIdentifier: "showNewRecipeViewController", sender: self)
        }
        
        let editRecipeBookAction = UIAlertAction(title: "Edit Recipe Book", style: .default) { (action) in
            if let recipeBook = self.recipeBook, let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewRecipeBookViewController") as? NewRecipeBookViewController {
                vc.editingRecipeBook = recipeBook
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(newRecipeAction)
        if recipeBook != nil { actionSheet.addAction(editRecipeBookAction) }
        actionSheet.addAction(cancelAction)
        
       present(actionSheet, animated: true, completion: nil)
    }
    
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section != 0 else { return 1 }
        return currentRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryFilterCell", for: indexPath) as! CategoryFilterCell
            cell._target = self
            cell.setUpViews()
            cell.fillData()
            return cell
        }
        
        let recipe = currentRecipes[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        cell._target = self
        cell.setUpViews()
        cell.fillData(recipe: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 1 else { return 0 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 1 else { return nil }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController {
            vc.recipe = currentRecipes[indexPath.item]
            self.show(vc, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.height / 8 // 100
        guard indexPath.section != 0 else { return 100 }
        return height
    }
}

extension RecipesViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else { filteredRecipes = recipeArr; tableView.reloadData(); return }
        let searchTxt = searchText.lowercased()
        
        filteredRecipes = recipeArr.filter({
            $0.name.lowercased().contains(searchTxt) ||
            $0.tagsArr.contains(searchTxt)
        })
        
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
        tableView.endUpdates()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
        tableView.endUpdates()
    }
}





